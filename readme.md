# Requirement

Hi Team - part of Compute and Networkings efforts to reduce Motherboard Dispatches we'd have a few requests for custom data reports that are not available in cube to ourselves, sponsored by Dexter.

few requirements:

timeframe: start of Q4, weekly breakdown for everything
Server MDR trend
Server Mobo MDR trend
regional/subregional/team breakdown of 2 and 3
MPD trend
work order status (approved/reworked/cancelled)
outlier MB Dispatch volume vs approver review % (we can provide outlier badges/nt logins)
outlier MB dispatch rate vs outlier overall dispatch rate
non outlier MB Dispatch volume vs approver review %
non outlier MB dispatch rate vs outlier overall dispatch rate
approved/rejected ratio of reviewed MB Work Orders
approved / rejected reasons ratio and list of reasons of reviewed MB Work Orders
approve / reject comments by approver
symptom classification on reviewed WOs
resolution classification on reviewed WOs
Digital Knowledge attach to case (article + guided flow)
RDR7 flag
agent hierarchy
dispatch review criteria

# Notes
### Meetings
### Meeting 1

there is urgency around this.

A project to reduce MDR Dispatch rate in poweredge.

In dec. initiative was launched they found outliers and they put them in dispatch review criteria.

Lightning if WO has MB then the WO will go into review and then they will check the case.

a few other requests around it.

meeting notes:

- dexter brown - joins this daily calls, they review actions and data to understand success.
- Kevin Whitlow is calling him every now and then asking the status of the project.
- They have a Scorecard - It provides an executive summary only they do have a bit of data which serves operational stuff. They want data to deep dive into the WO to understand the issues.
    - Check the issues on the cases and see how they can control it.
    - All this requires some detailed data for managers.
- **ISSUES** currently
- They have part of the data they dont have it all
- The data that they have is coming from many different sources.
- Mean Dispatch Rate, only MB MDR
- outliers view? how to identify outliers.
    - centralized location for the outlier list.
    - norbert will share it, need to figure out how to join it, at this time its only NT ID.
### Personal Notes:

- Build out the WC query with summarized information, this will reshape the WC dashboard as well.
- Gather requirements, and then build an excel report.
    - Motherboard dispatches
    - MDR RDR
    - Poweredge
    - 13 weeks Transactional
    - Output ??
- Check to see if this can be done with Pandas with Datapane.
- Require Outliers view, but will have to be integrated later, since the data currently is not in DDL
- Dispatch Criteria has to be looked into, this information is hard to get, need to find out where to integrate that from, approval comments are the best bet.
- Request MDR information from the services engineering team to get calculation for MDR.
- Nadine and Gordon for Outlier info.

### Meeting Notes: team meeting

- MMP - Multip Major Parts dispatches. (DISPATCH CRITERIA)
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/64bcbf82-1aac-4d93-a315-8399f7120e3b/Untitled.png)
    
- SINGLE MAJOR PARTS - single parts dispatch.

### Meeting with Nitin on MDR

- Customer region
- Remove PFR from GSD Tower

Meeting

- Dashboard
    - have the dashboard ready
- Transactional
    - Approval criteria met (to check if the WO went into review)
    - Date column
    - Knowledge Article solution attached. Guided Flow. Digital Resolution.
    - RDR %
        - removed
            - unnecessary columns like gcc and dummy tag
- QTD and WTD and YTD

### Addition to datasets

- Digital Resolution - KB articles attached
- Attach rate, Guided solution attached to the cases on which WO was created. - Guided Solutions attached. DSN articles
    - KCS attached
    - KCS Solved - did it resolve the issue or not.
    - view for the guided solution and kb article.
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/53a147bc-fed8-428f-aa7d-8f0c7916556a/Untitled.png)
    
- approval criteria met
    - appv_cmt_desc
- even more urgent monday
    - all mmpd wo and approval rate of those.
    - review all mmpd wo

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/0910aa7a-4c4c-4aa2-8f68-0dda33af6472/Untitled.png)

notes:

- mobo low 204 vs 9
- mmpd low
- case count low - should be between 12000
- mdr count

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/125b3726-8b81-4680-90ba-cc7d043a230c/Untitled.png)

mpd calculation is there in cube.

Case Open WO Rate COWR

2 types of classification (check if this can be brought in)

symptom class (case level information)

resolution class (case level information)

# Report - Poweredge transactional 4 weeks rolling 
## Transactional Report for Manager administration and case management

### Report Filtering and Limitations
The report captures 4 weeks rolling data, it is designed to provide the latest available case and WO information, for administration and scrubs
- Data is stored at a transactional level meaning case and WO numbers are available
- Filtered at query level 
  - ISG
  - capture 5 weeks.
  - Poweredge servers only.
  - Cases for
    - KCS and Guided Flow
    - Cases created
    - Case Calendar for COWR
- Filters on Report
  - L5 managers (Brown, Dexter & Paris, Claudia & Yap, Diane)
  - 3 Weeks rolling
  - Case Channel excludes Bulk and DOSD
  - Filtering to L5 managers primarily excludes RPA WO. However, create_process filter is set to exclude RPA
- Report has the following fields available.
  - Customer Hierarchy
  - Agent Hierarchy (created & approved) [WO]
  - Product Hierarchy
  - Calendar Case & WO
  - Case
    - status
    - number
    - kcs
    - guided flow
  - WO
    - Criteria
    - Criteria Status
    - Types
    - Status
    - Number
    - MMPD Counts (total number of Major parts)
    - MMPD WO (WO containing Major parts)
    - MB Counts (total number of MB parts)
    - MB WO (WO containing MB parts)
  - Metrics
    - Primary
      - RDR
      - MDR
      - MPD
      - MMPD
      - MB
      - PPD
      - COWR - 
        - (Case Open WO Rate is a special case and is developed on a standalone tab to get an accurate count of cases created)
    - Secondary
      - MMPD WO / MDR WO
      - MB WO / MDR WO
      - KCS Solved / KCS attached
      - CDR - Case Dispatch Rate
- Data is sourced out of USDM tables.
- Multiple tabs are available to view and slice that data with.
  - Primary tabs
    - MDR - MPD Trainer
    - Consolidated View