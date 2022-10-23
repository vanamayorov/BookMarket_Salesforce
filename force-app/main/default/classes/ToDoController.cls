public with sharing class ToDoController {
  @AuraEnabled
  public static string addToDo(String payload) {
    try {
      ToDo payloadObject = (ToDo) JSON.deserialize(payload, ToDo.class);
      ToDo__c tsk = new Todo__c();
      tsk.Name = payloadObject.todoName;
      tsk.Done__c = payloadObject.done;

      insert tsk;
      return String.valueOf(tsk.Id);
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(cacheable=true)
  public static void updateToDo(String payload) {
    try {
      ToDo payloadObject = (ToDo) JSON.deserialize(payload, ToDo.class);
      ToDo__c tsk = new Todo__c();
      tsk.Id = payloadObject.todoId;
      tsk.Name = payloadObject.todoName;
      tsk.Done__c = payloadObject.done;

      update tsk;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static String deleteToDo(String todoId) {
    try {
      ToDo__c tsk = new Todo__c();
      tsk.Id = todoId;
      delete tsk;
      return tsk.Id;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(cacheable=true)
  public static List<ToDo> getAllTodos() {
    List<ToDo__c> tsks = Database.query(
      'SELECT Id, Name, CreatedDate, Done__c FROM ToDo__c WHERE CreatedDate = LAST_N_DAYS:7 ORDER BY CreatedDate DESC'
    );

    return getToDos(tsks);
  }

  @AuraEnabled
  public static List<ToDo> getCurrentTodos() {
    List<ToDo__c> tsks = Database.query(
      'SELECT Id, Name, CreatedDate, Done__c FROM ToDo__c WHERE CreatedDate = TODAY ORDER BY CreatedDate DESC'
    );

    return getToDos(tsks);
  }

  public static List<ToDo> getToDos(List<ToDo__c> tsks) {
    List<ToDo> todos = new List<ToDo>();
    for (ToDo__c tsk : tsks) {
      ToDo todo = new ToDo();
      todo.todoId = tsk.Id;
      todo.todoName = String.valueOf(tsk.get('Name'));
      todo.done = Boolean.valueOf(tsk.get('Done__c'));
      todos.add(todo);
    }
    return todos;
  }

  class Todo {
    @AuraEnabled
    public String todoId;
    @AuraEnabled
    public String todoName;
    @AuraEnabled
    public Boolean done;
  }
}
