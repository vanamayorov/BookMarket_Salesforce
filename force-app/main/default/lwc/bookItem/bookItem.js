import { LightningElement, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import buyBook from "@salesforce/apex/BookController.buyBook";
import Id from "@salesforce/user/Id";

export default class BookItem extends LightningElement {
  @api book;
  quantityToBuy = 1;
  userId = Id;

  buyBook() {
    const payload = {
      bookId: this.book.Id,
      userId: this.userId,
      bookQty: this.quantityToBuy,
      price: this.book.Price__c,
      bookstoreId: this.book.Bookstore__r.Id
    };

    buyBook({ payload: JSON.stringify(payload) })
      .then(() => {
        this._showToaster(
          "Success",
          `Bought new book: ${this.book.Book_Title__c}`,
          "success"
        );
        this.dispatchEvent(new CustomEvent("buybook"));
      })
      .catch((err) => {
        this._showToaster("Error!", err.body.message, "error");
      });
  }

  handleQuantityChange(event) {
    const quantity = +event.detail.value;
    this.quantityToBuy = quantity;
  }

  get invalidInput() {
    const validity = this.template
      .querySelector(".quantity-input")
      ?.checkValidity();
    if (validity === undefined) return false;
    return !validity;
  }

  _showToaster(title, message, variant) {
    this.dispatchEvent(
      new ShowToastEvent({
        title,
        message,
        variant
      })
    );
  }
}
