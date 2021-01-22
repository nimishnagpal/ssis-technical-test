# ssis-technical-test


<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul><li><a href="#built-with">Built With</a></li></ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul><li><a href="#prerequisites">Prerequisites</a></li>
          <li><a href="#Configure The Solution">Configure The Solution</a></li>
      </ul>
    </li>
    <li>
      <a href="#how-package-works?">How package works?</a>
      <ul>
        <li><a href="#get-exchange-rates-from-api">Get exchange rates from API</a></li>
        <li><a href="#load-sales_sewcurencyrate">Load Sales_NewCurencyRate</a></li>
        <li><a href="#load-new-fxrates-into-factcurrencyrate">Load New FXRates into FactCurrencyRate</a></li>
        <li><a href="#load-factsalesorder">Load FactSalesOrder</a></li>
      </ul>
    </li>
    <li>
      <a href="#additional-features">Additional Features</a>
      <ul>
        <li><a href="#event-handler">Event Handler</a></li>
        <li><a href="#logging-onfailure-&-onwarning">Logging OnFailure & OnWarning</a></li>
        <li><a href="#allow-only-latest-records-and-decide-to-insert-or-update-record">Allow ONLY latest records and Decide to Insert Or Update record</a></li>
      </ul>
    </li>
    <li>
      <a href="#how-your-solution-could-be-made-better">How your solution could be made better</a>
      <ul>
        <li><a href="#data-Validation">Data Validation</a></li>
        <li><a href="#sending-out-email-notification">Sending out email notification</a></li>
        <li><a href="#rrror-handling">Error Handling</a></li>
        <li><a href="#checkpoint-in-lengthy-etl-flow">Checkpoint in lengthy ETL flow</a></li>
        <li><a href="#applying-indexing-in-sql-table">Applying Indexing in SQL Table</a></li>
      </ul>
    </li>
  </ol>
</details>



## About The Project
The package is built to accomodate the business scenario where the requirement is to have a FACT table in the AdventureWorksDW which allows to query to aggregate `Total sales amount in New Zealand Dollars`, `Total sales amount in US Dollars`, `Total Quantity ordered` to be grouped upon the `Calendar Year of Order` and the `Colour of the Product`.

### Built With

* SQL Server Databases : AdventureWorks2016 & AdventureWorksDW2016.
* Visual Studio 2019 with installed SSIS Project extension.
* Powershell Script.


## Getting Started
Best way to use the package is to either clone the repository to your local system or Download the solution as zip file. The repo has **solution package**  and an additional **SQL Script**. 

Starting with **solution package**, you must meet the Prerequisites before you run the package. 

### Prerequisites
Here are the list of softwares and packages you will need to install.
* Install [Visual Studio 2015](https://visualstudio.microsoft.com/vs/older-downloads/) or newer (Recommended)  OR Install [SSDT version15](https://docs.microsoft.com/en-us/sql/ssdt/previous-releases-of-sql-server-data-tools-ssdt-and-ssdt-bi?view=sql-server-ver15) or newer. (Recommended)
* [SQL Server Management Studio 2016](https://docs.microsoft.com/en-us/sql/ssms/release-notes-ssms?view=sql-server-ver15) or newer (Recommended)
* [AdventureWorks databases](https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms) any

### Configure the Solution 
Open the `ssis-technical-test.sln` on your local machine. It will open the visual studio or SSDT.  Open the package `Load FactSalesOrder.dtsx` from the *Solution Explorer*. Edit the package parameters as you open the package.

![PackageParameters](https://github.com/NimNagpal/Daemon/blob/master/screenshots/PackageParameter.png?raw=true)

Make sure you provide the `ProjectPath`, which is the path of the directory of the project file. The parameters `serverName`, `OLTPdatabase` & `DWdatabase` are filled as per the server name and databasename in your local machine.

> NOTE: I am assuming that the Adventure Works is installed on your local machine and it doesn't require password to connect and database will be allowed to connect through your Window Login Authentication. If not, the case package configurations will need to change. 

> While opening the package `Load FactSalesOrder.dtsx` for the first time it might raise an *ERROR MESSAGE*. Continue opening the package and provide the Package Parameters. It will fix the error 


## How package works? 
> The ETL flow is based on my assumption of the data. Each assumption is reasoned below.
Once the package is configured and Package Parameters have the new system value, the package can be triggered by clicking `Start` (or press `F5`). The package has ***4 Control Flow tasks***. Each task performs its functionality. 

#### Get exchange rates from API
The taks calls a powershell script to fetch the exchanges rates from Web - https://exchangeratesapi.io/ and loads it into a csv file. The api call is driven with variables like
- `startDate`
- `endData` 
- `base` currency 
- `symbol` as per currency required 


> ***Alternate ways of getting the exchange rate*** could be
> 1. Use **Script Task** and write C# or VB in  *.Net Framework* to fetch the exchange rate through WebClient and then load it into the table.
> 2. Use **Web Service Task** to call the WebAPI and store the output in the file. This method require to *download WSDL(Web Service Definition Language)* from the Web source.  

#### Load Sales_NewCurencyRate
This task loads the currency rates from the Flat File downloaded from the above task and then transforms the data to proper data types and load it into newly created table `AdventureWorks2016.Sales.NewCurencyRate` in the OLTP database. 

#### Load New FXRates into FactCurrencyRate
This task contains a SQL Script. The purpose of using this task it to bring proper structure information for the exchange rate. 

>The ***issue with the exchange rate coming from the WebAPI*** is that the exchange rates are not continuous and some of the days are missing. So, the script loads the exchange rate for all the relevant date while filling the previous day's exchange rate in case it is missing.

#### Load FactSalesOrder
This is the most important data flow task of the package, where the data is read from `Sales.SalesOrderDetail` and `Sales.SalesOrderHeader` to retrieve the Order details. Using the SalesOrders,  a new Fact table is loaded `AdventureWorksDW2016.dbo.FactSalesOrders`. This fact table receives the Key from `DimProduct` and `DimCurrency` and some derived columns that calculates a few of the required fact information.

## Additional Features
A few of the additional features are added to the package for better usage as listed.

#### Event Handler
An event handler **onPreValidation** of the task `Load FactSalesOrder`and `Load Sales_NewCurencyRate` are added to avoid failure because the task within these event handlers will `Check if the required table exists and accordingly creates the table`.

![EventHandler](https://github.com/NimNagpal/Daemon/blob/master/screenshots/eventHandler.png)

#### Logging OnFailure & OnWarning
Logging mechanism is enabled to allow to log the failures and the warning on any of the tasks.

#### Allow ONLY latest records and Decide to Insert Or Update record
The source components in task `Load FactSalesOrder` *determines the records that are NOT processed* and allow ONLY those to flow through the data flow task. Also the Lookup with the destination table allows the package to decide whether `the record is a New record (therefore Insert)` OR is `an existing record (therefore Update)`

## How your solution could be made better
There could be a variety of areas that can be improved if I think of this as a real business case. In a real business scenario, the details at the level of understanding the problem and the way to answer could be a lot different. Thinking about some of the possible option are listed below:

#### Data Validation
When the data moves from the source system to data warehouse, it is recommended to perform the data validations. Although, in the current situation there is only one source and the data in the AdventureWorks database is uniform. Otherwise, in case of multiple source systems, it is important to validate the fields for correct data type values, NULL values, data ranges, etc. 

#### Sending out email notification
The email notification can be useful to:
- some business needs, so as to notify when that data is available to use for the stakeholders
- and to warn operations(internal teams), about any warnings or failures.
Email can be triggerred from the Event Handlers or within the control flow.

#### Error Handling
Error handling is quite important concept to avoid data loss. In case of data discrepancy, that flow can be directed toward Error Handling tasks and such scenarios can be handled without interrupting the complete flow.

#### Checkpoint in lengthy ETL flow
The checkpoint comes handy for the lengthy and time taking Flow, because in such scenario checkpoints of the package execution can be saved and can allow to restart the package  from the failed checkpoint. This could save unnecessary re-processing, time and resources on the execution of a package.

#### Applying Indexing in SQL Table
Additionally, applying indexes on the Dim & Fact Table can help business in fetching results faster. But, it is important to be aware of the limitation that an Index on table also slows down the Insert/Update process thus affect SSIS packages.  




