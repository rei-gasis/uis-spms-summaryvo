SELECT PO.SCORECARD_ID,
  PO.OBJECTIVE_ID,
  PO.NAME objective_name,
  PO.START_DATE,
  PO.DETAIL,
  PO.COMMENTS,
  PO.SUCCESS_CRITERIA,
  PO.WEIGHTING_PERCENT,
  PO.GROUP_CODE,
  PO.ATTRIBUTE14 BASIS,
  PO.ATTRIBUTE6 CATEGORY,
  PO.ATTRIBUTE4 BUDGET,
  PO.ATTRIBUTE11 DIVISIONS,
  PO.ATTRIBUTE12 REMARKS
FROM per_objectives PO
WHERE po.scorecard_id = :ParamScorecardId
UNION
SELECT xx_api.transaction_ref_id SCORECARD_ID,
  DECODE(extractvalue(VALUE(xx_row), '/ObjectiveEORow/ObjectiveId'), '(null)', 0, extractvalue(VALUE(xx_row), '/ObjectiveEORow/ObjectiveId')) objective_id,
  extractvalue(VALUE(xx_row), '/ObjectiveEORow/Name') objective_name,
  to_date(extractvalue(VALUE(xx_row), '/ObjectiveEORow/StartDate'), 'RRRR-MM-DD') start_date,
  extractvalue(VALUE(xx_row), '/ObjectiveEORow/Detail') detail,
  extractvalue(VALUE(xx_row), '/ObjectiveEORow/Comments') comments,
  extractvalue(VALUE(xx_row), '/ObjectiveEORow/SuccessCriteria') SUCCESS_CRITERIA,
  to_number(extractvalue(VALUE(xx_row), '/ObjectiveEORow/WeightingPercent')) WEIGHTING_PERCENT,
  extractvalue(VALUE(xx_row), '/ObjectiveEORow/GroupCode') GROUP_CODE,
  extractvalue(VALUE(xx_row), '/ObjectiveEORow/Attribute14') BASIS,
  extractvalue(VALUE(xx_row), '/ObjectiveEORow/Attribute6') ATTRIBUTE6,
  extractvalue(VALUE(xx_row), '/ObjectiveEORow/Attribute4') BUDGET,
  extractvalue(VALUE(xx_row), '/ObjectiveEORow/Attribute11') DIVISIONS,
  extractvalue(VALUE(xx_row), '/ObjectiveEORow/Attribute12') REMARKS
FROM HR_API_TRANSACTIONS xx_api,
  TABLE(xmlsequence(extract(xmlparse(document transaction_document wellformed), '/Transaction/TransCache/AM/TXN/EO/ObjectiveEORow'))) xx_row
WHERE xx_api.transaction_ref_id = :ParamScorecardId