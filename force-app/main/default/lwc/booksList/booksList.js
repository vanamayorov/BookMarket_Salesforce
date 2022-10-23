import { LightningElement, api, wire } from "lwc";
import { refreshApex } from "@salesforce/apex";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getBooksByCity from "@salesforce/apex/BookController.getBooksByCity";

export default class BooksList extends LightningElement {
  @api cityId;
  books = [];
  booksResults;

  @wire(getBooksByCity, { cityId: "$cityId" })
  wiredBooks(value) {
    this.booksResults = value;
    const { error, data } = value;

    if (error) {
      this.books = [];

      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error",
          message: error.body.message,
          variant: "error"
        })
      );
    }

    if (data) {
      this.books = data;
    }
  }

  triggerBooksResult() {
    return refreshApex(this.booksResults);
  }
}
