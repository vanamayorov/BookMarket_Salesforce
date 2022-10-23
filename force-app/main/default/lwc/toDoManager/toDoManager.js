import { LightningElement, track } from "lwc";
import addToDo from "@salesforce/apex/ToDoController.addToDo";
import getCurrentTodos from "@salesforce/apex/ToDoController.getCurrentTodos";

export default class ToDoManager extends LightningElement {
  hour = 0;
  @track time = "";
  @track todos = [];
  // @track variable; reactive variable
  connectedCallback() {
    this.getTime();
    this.fetchTodos();
    setInterval(() => {
      this.getTime();
    }, 1000);
  }

  getTime() {
    const date = new Date();
    this.hour = date.getHours();
    const min = date.getMinutes();

    this.time = `${this.getHour(this.hour)}:${this.getDoubleDigit(
      min
    )} ${this.getMidDay(this.hour)}`;
  }

  get greeting() {
    if (this.hour < 12) return "Good Morning";
    if (this.hour >= 12 && this.hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  getHour(hour) {
    return hour === 0 ? 12 : hour > 12 ? hour - 12 : hour;
  }

  getMidDay(hour) {
    return hour >= 12 ? "PM" : "AM";
  }

  getDoubleDigit(digit) {
    return digit < 10 ? "0" + digit : digit;
  }

  addToDoHandler() {
    const inputBox = this.template.querySelector("lightning-input");
    const todo = {
      todoName: inputBox.value.trim(),
      done: false
    };
    addToDo({ payload: JSON.stringify(todo) })
      .then((response) => {
        console.log("Inserted successfully");
        this.fetchTodos();
      })
      .catch((err) => {
        console.error("Error happened", err);
      });
    this.todos.push(todo);
    inputBox.value = "";
  }

  fetchTodos() {
    getCurrentTodos()
      .then((res) => {
        if (res) {
          this.todos = res;
        }
      })
      .catch((err) => console.log(err));
  }

  get upcomingTasks() {
    return this.todos?.filter((todo) => !todo.done) ?? [];
  }

  get completedTasks() {
    return this.todos?.filter((todo) => todo.done) ?? [];
  }

  updateHandler(event) {
    if (event) {
      this.fetchTodos();
    }
  }

  deleteHandler(event) {
    if (event) {
      this.fetchTodos();
    }
  }
}
