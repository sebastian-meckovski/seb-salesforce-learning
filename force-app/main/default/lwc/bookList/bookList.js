import { LightningElement, track, wire } from 'lwc';
import getBooks from '@salesforce/apex/BookController.getBooks';
import updateBookRating from '@salesforce/apex/BookController.updateBookRating';
import { refreshApex } from '@salesforce/apex';

export default class BookList extends LightningElement {
    @track ratingEdits = {};
    @wire(getBooks) books;

    handleRatingInput(event) {
        const bookId = event.target.dataset.id;
        this.ratingEdits = { ...this.ratingEdits, [bookId]: event.target.value };
    }

    async handleSaveRating(event) {
        const bookId = event.target.dataset.id;
        const newRating = parseFloat(this.ratingEdits[bookId]);
        try {
            await updateBookRating({ bookId, newRating });
            this.ratingEdits = { ...this.ratingEdits, [bookId]: '' };
            // Refresh the wire adapter
            await refreshApex(this.books);
        } catch (err) {
            // Optionally handle error
            // eslint-disable-next-line no-console
            console.error('Error updating rating', err);
        }
    }
}