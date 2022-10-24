import { LightningElement, api, wire } from "lwc";
import { refreshApex } from "@salesforce/apex";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getBooksByCity from "@salesforce/apex/BookController.getBooksByCity";

export default class BooksList extends LightningElement {
  @api cityId;
  books = [];
  booksResults;
  isLoading = false;

  @wire(getBooksByCity, { cityId: "$cityId" })
  wiredBooks(value) {
    this.booksResults = value;
    const { error, data } = value;
    this.isLoading = true;

    if (error) {
      this.books = [];

      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error",
          message: error.body.message,
          variant: "error"
        })
      );
      this.isLoading = false;
    }

    if (data) {
      this.books = data;
      this.isLoading = false;
    }
  }

  triggerBooksResult() {
    return refreshApex(this.booksResults);
  }
}
