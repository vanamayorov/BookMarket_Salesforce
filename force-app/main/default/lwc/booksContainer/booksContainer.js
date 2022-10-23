import { LightningElement, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getCities from "@salesforce/apex/CityController.getCities";

export default class BooksContainer extends LightningElement {
  cityId = "";
  cities = [];

  @wire(getCities)
  wiredCities({ data, error }) {
    if (error) {
      this.cities = [];

      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error",
          message: error.body.message,
          variant: "error"
        })
      );
    }

    if (data) {
      this.cities = data.map((city) => ({
        label: city.Name,
        value: city.Id
      }));
    }
  }

  handleSelectChange(event) {
    this.cityId = event.detail;
  }
}
