# Veltora Inc. — Methodology & Design Decisions

## Building Around One Source of Truth

Every comp rate, quota, accelerator threshold, and bonus tier 
lives in one place: plan_catalog. The commission engine pulls 
from it, it never stores anything itself. That means changing 
a comp plan touches exactly one sheet. If a payout looks wrong, 
you know exactly where to look.

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
actually run their comp cycles and closes the door on reps 
gaming monthly targets.

## Why Held Meetings, Not Booked

SDRs are measured on qualified held meetings, not booked meetings. 
A meeting only counts if the rep clears the minimum show rate for 
their segment — 75% for Enterprise, 70% for Mid-Market, 65% for 
SMB. The thresholds vary because the buyer profiles do. An 
enterprise prospect who ghosts is a different problem than an 
SMB no-show.
