import { LightningElement, api } from "lwc";

export default class CitySelect extends LightningElement {
  @api cityId;
  @api cities;

  handleSelectChange(event) {
    this.dispatchEvent(
      new CustomEvent("cityselect", {
        detail: event.detail.value
      })
    );
  }
}
