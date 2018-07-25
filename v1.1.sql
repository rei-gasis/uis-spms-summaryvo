SELECT xx_api.transaction_ref_id SCORECARD_ID,
  DECODE(extractvalue(VALUE(xx_row), '/ObjectiveEORow/ObjectiveId'), '(null)', 0, extractvalue(VALUE(xx_row), '/ObjectiveEORow/ObjectiveId')) objective_id,
  NVL(extractvalue(VALUE(xx_row), '/ObjectiveEORow/Name'),po.name) objective_name,
  NVL(to_date(extractvalue(VALUE(xx_row), '/ObjectiveEORow/StartDate'), 'RRRR-MM-DD') ,po.start_date) start_date,
  NVL(extractvalue(VALUE(xx_row), '/ObjectiveEORow/Detail'), po.detail) detail,
  NVL(extractvalue(VALUE(xx_row), '/ObjectiveEORow/Comments'), po.comments) comments,
  NVL(extractvalue(VALUE(xx_row), '/ObjectiveEORow/SuccessCriteria'), po.success_criteria) SUCCESS_CRITERIA,
  NVL(to_number(extractvalue(VALUE(xx_row), '/ObjectiveEORow/WeightingPercent')), po.weighting_percent) WEIGHTING_PERCENT,
  NVL(extractvalue(VALUE(xx_row), '/ObjectiveEORow/GroupCode'), po.group_code) GROUP_CODE,
  NVL(extractvalue(VALUE(xx_row), '/ObjectiveEORow/Attribute14') ,po.attribute14) BASIS,
  NVL(extractvalue(VALUE(xx_row), '/ObjectiveEORow/Attribute6') ,po.attribute6) ATTRIBUTE6,
  NVL(extractvalue(VALUE(xx_row), '/ObjectiveEORow/Attribute4'), po.attribute4) BUDGET,
  NVL(extractvalue(VALUE(xx_row), '/ObjectiveEORow/Attribute11'), po.attribute11) DIVISIONS,
  NVL(extractvalue(VALUE(xx_row), '/ObjectiveEORow/Attribute12'), po.attribute12) REMARKS
FROM HR_API_TRANSACTIONS xx_api,
  TABLE(xmlsequence(extract(xmlparse(document transaction_document wellformed), '/Transaction/TransCache/AM/TXN/EO/ObjectiveEORow'))) xx_row,
  per_objectives po
WHERE xx_api.transaction_ref_id = :ParamScorecardId
AND po.objective_id (+) = DECODE(extractvalue(VALUE(xx_row), '/ObjectiveEORow/ObjectiveId'), '(null)', 0, extractvalue(VALUE(xx_row), '/ObjectiveEORow/ObjectiveId'))
AND extractvalue(VALUE(xx_row), '/ObjectiveEORow/@PS') <> 3