import { LightningElement, api, wire } from 'lwc';
import getJobById from '@salesforce/apex/JobTimelineController.getJobById';

const STATUS_STEPS = ['New', 'Assigned', 'In Progress', 'Completed'];

export default class JobTimeline extends LightningElement {
    
    @api recordId;
    job;
    
    @wire(getJobById, { jobId: '$recordId' })
    wiredJob({ error, data }) {
        if (data) {
            this.job = data;
        } else if (error) {
            console.error('Error fetching job:', error);
        }
    }
    
    get steps() {
        const currentIndex = STATUS_STEPS.indexOf(
            this.job ? this.job.Status__c : ''
        );
        
        return STATUS_STEPS.map((step, index) => {
            const isCompleted = index <= currentIndex;
            return {
                label: step,
                isCompleted: isCompleted,
                isLast: index === STATUS_STEPS.length - 1,
                circleClass: isCompleted 
                    ? 'step-circle step-circle-completed' 
                    : 'step-circle',
                lineClass: isCompleted 
                    ? 'step-line step-line-completed' 
                    : 'step-line'
            };
        });
    }
}