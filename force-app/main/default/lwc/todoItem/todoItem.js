import { LightningElement, api } from "lwc";
import updateToDo from "@salesforce/apex/ToDoController.updateToDo";
import deleteToDo from "@salesforce/apex/ToDoController.deleteToDo";

export default class TodoItem extends LightningElement {
  @api todo;
  @api done = false;

  get containerClass() {
    return this.done ? "todo completed" : "todo upcoming";
  }

  get iconName() {
    return this.done ? "utility:check" : "utility:add";
  }

  updateHandler() {
    const todo = {
      todoId: this.todo.todoId,
      todoName: this.todo.todoName,
      done: !this.done
    };

    updateToDo({ payload: JSON.stringify(todo) })
      .then(() => {
        const updateEvent = new CustomEvent("update", { detail: todo });
        this.dispatchEvent(updateEvent);
      })
      .catch((err) => console.error(err));
  }

  deleteHandler() {
    deleteToDo({ todoId: this.todo.todoId })
      .then(() => {
        const deleteEvent = new CustomEvent("delete", {
          detail: this.todo.todoId
        });
        this.dispatchEvent(deleteEvent);
      })
      .catch((err) => console.error(err));
  }
}
