import { LightningElement, wire } from 'lwc';
import getBooks from '@salesforce/apex/BookController.getBooks';

export default class BookList extends LightningElement {
    @wire(getBooks) books;
}