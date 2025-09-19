import { LightningElement } from 'lwc';

export default class DashboardOverview extends LightningElement {
    tiles = [
        {
            id: 'pending',
            value: '7',
            label: 'Pending Approvals',
            delta: '↑ 2 from yesterday',
            deltaClass: 'delta-red'
        },
        {
            id: 'approved',
            value: '10',
            label: 'Approved this Week',
            delta: '↑ 1 from last week',
            deltaClass: 'delta-red'
        },
        {
            id: 'rejected',
            value: '2',
            label: 'Rejected this Week',
            delta: '↑ 1 from last week',
            deltaClass: 'delta-red'
        },
        {
            id: 'pendingValue',
            value: '$12,450.00',
            label: 'Total Pending Value',
            delta: 'Similar to average',
            deltaClass: 'delta-gray'
        },
        {
            id: 'approvalRate',
            value: '94%',
            label: 'Monthly Approval Rate',
            delta: '↑ 4% from last month',
            deltaClass: 'delta-green'
        },
        {
            id: 'avgResponse',
            value: '2d',
            label: 'Average Response Time',
            delta: '↑ 5h increase',
            deltaClass: 'delta-red'
        }
    ];
}