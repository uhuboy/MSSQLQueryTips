-- หา Query ที่ใช้เวลา (elapsed time) นานที่สุด

SELECT TOP 20
    qs.total_elapsed_time / qs.execution_count AS avg_elapsed_time,
    qs.total_elapsed_time AS total_elapsed_time,
    qs.execution_count,
    qp.query_plan,
    SUBSTRING(st.text, 
              (qs.statement_start_offset/2)+1,
              ((CASE qs.statement_end_offset 
                    WHEN -1 THEN DATALENGTH(st.text)
                    ELSE qs.statement_end_offset 
                END - qs.statement_start_offset)/2)+1
    ) AS query_text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY avg_elapsed_time DESC;
