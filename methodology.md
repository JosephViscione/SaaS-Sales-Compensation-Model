# Veltora Inc. — Methodology & Design Decisions

## Building Around One Source of Truth

Every comp rate, quota, accelerator threshold, and bonus tier lives in one place: plan_catalog. The commission engine pulls from it, it never stores anything itself. That means changing a comp plan touches exactly one sheet. If a payout looks wrong, you know exactly where to look.

## Why SUMPRODUCT Instead of Pivot Tables

Pivot tables break when the data structure changes and need 
manual refreshing. SUMPRODUCT doesn't. Every summary figure 
in this model recalculates the moment any input changes, which 
makes it an actual planning tool rather than a report you 
have to babysit.

## How Accelerators Actually Pay Out

Monthly commissions are paid at the standard rate. If a rep 
crosses an accelerator threshold by quarter end, the difference 
is paid as a true-up. This matches how most SaaS companies 
actually run their comp cycles and close the door on reps 
gaming monthly targets.

## Why Held Meetings, Not Booked

SDRs are measured on qualified held meetings, not booked meetings. 
A meeting only counts if the rep clears the minimum show rate for 
their segment — 75% for Enterprise, 70% for Mid-Market, 65% for 
SMB. The thresholds vary because the buyer profiles do. An 
enterprise prospect who ghosts is a different problem than an 
SMB no-show.

## Why SQL on Top of Excel

The Excel model answers operational questions: what each rep earned, how the team performed, and where accelerators fired. SQL answers structural questions: which segments are generating the best return on comp spend, what attrition actually costs, and how attainment is distributed across the team. These are different questions, and they need different tools. The underlying data was exported to a SQLite database and queried with four purpose-built scripts, each targeting a specific planning question.

## Why a Separate Dashboard
The Excel dashboard is designed for someone already inside the workbook. The interactive dashboard is designed for someone who will never open it. All the same findings surfaced in a format that requires no prior context. The filters are wired to the real underlying data, so any stakeholder can slice by segment, role, status, or quarter and see the numbers update in real time. That is a different kind of deliverable than a spreadsheet, and it serves a different audience. Additionally, the dashboard, built with Python's plotly, illustrates a higher level of BI capabilities. 
