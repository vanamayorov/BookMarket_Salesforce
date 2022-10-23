import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getReaderBooksList from "@salesforce/apex/ReaderBookController.getReaderBooksList";
import Id from "@salesforce/user/Id";

const columns = [
  { label: "Book Title", fieldName: "title" },
  { label: "Author", fieldName: "author" },
  { label: "Quantity", fieldName: "quantity" }
];

export default class RelatedList extends LightningElement {
  data = [];
  columns = columns;

  connectedCallback() {
    this.fetchRelatedList();
  }

  fetchRelatedList() {
    getReaderBooksList({ userId: Id })
      .then((res) => {
        this.data = res.map((book) => ({
          title: book.Book__r.Book_Title__c,
          quantity: book.Number_Of_Books__c,
          author: book.Book__r.Author__r.Name
        }));
      })
      .catch((err) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error",
            message: err.body.message,
            variant: "error"
          })
        );
      });
  }
}
