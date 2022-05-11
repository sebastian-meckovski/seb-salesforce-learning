import React from 'react';
import 'devextreme/data/odata/store';
import DataGrid, {
  Column,
  Pager,
  Paging,
  FilterRow,
  Lookup,
  StateStoring
} from 'devextreme-react/data-grid';
import './grid.css'
import { ColumnFixing } from 'devextreme-react/tree-list';

export default function Task() {
  return (
    <React.Fragment>
      <h2 className={'content-block'}>Tasks</h2>
      <div className={'grid-outer-container'}>
        <DataGrid
          className={'grid-container'}
          dataSource={dataSource}
          showBorders={false}
          focusedRowEnabled={true}
          defaultFocusedRowIndex={0}
          columnAutoWidth={true}          
          
          >
          <StateStoring enabled={true} type="localStorage" storageKey="WardApp_FilterKey" />
          {/* <Paging defaultPageSize={100} />
          <Pager showPageSizeSelector={false} showInfo={true} /> */}
          <FilterRow visible={true} />
          <ColumnFixing enabled={true} />

          <Column dataField={'Task_ID'} width={90} />
          <Column
            dataField={'Task_Subject'}
            width={190}
            caption={'Subject'}
            fixed={true}
            // hidingPriority={8}
          />
          <Column
            dataField={'Task_Status'}
            caption={'Status'}
            // hidingPriority={6}
          />
          <Column
            dataField={'Task_Priority'}
            caption={'Priority'}
            // hidingPriority={5}
          >
            <Lookup
              dataSource={priorities}
              valueExpr={'value'}
              displayExpr={'name'}
              />
          </Column>
          <Column
            dataField={'ResponsibleEmployee.Employee_Full_Name'}
            caption={'Assigned To'}
            allowSorting={false}
            fixedPosition
            // hidingPriority={7}
            />
          <Column
            dataField={'Task_Start_Date'}
            caption={'Start Date'}
            dataType={'date'}
            // hidingPriority={3}
            />
          <Column
            dataField={'Task_Due_Date'}
            caption={'Due Date'}
            dataType={'date'}
            // hidingPriority={4}
            />
          <Column
            dataField={'Task_Priority'}
            caption={'Priority'}
            name={'Priority'}
            // hidingPriority={1}
            />
          <Column
            dataField={'Task_Completion'}
            caption={'Completion'}
            // hidingPriority={0}
            />
        </DataGrid>
      </div>
    </React.Fragment>
)}

const dataSource = {
  store: {
    type: 'odata',
    key: 'Task_ID',
    url: 'https://js.devexpress.com/Demos/DevAV/odata/Tasks'
  },
  expand: 'ResponsibleEmployee',
  select: [
    'Task_ID',
    'Task_Subject',
    'Task_Start_Date',
    'Task_Due_Date',
    'Task_Status',
    'Task_Priority',
    'Task_Completion',
    'ResponsibleEmployee/Employee_Full_Name'
  ]
};

const priorities = [
  { name: 'High', value: 4 },
  { name: 'Urgent', value: 3 },
  { name: 'Normal', value: 2 },
  { name: 'Low', value: 1 }
];
