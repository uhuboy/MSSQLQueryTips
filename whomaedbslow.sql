-- ใช้เพื่อดูว่า “ใครทำให้ระบบช้า” และ query ไหนกำลังกิน CPU สูง

SELECT  
    der.session_id,
    DB_NAME(der.database_id) AS database_name,
    deqp.query_plan,
    SUBSTRING(dest.text, der.statement_start_offset / 2,
        (CASE 
            WHEN der.statement_end_offset = -1 
                THEN DATALENGTH(dest.text)
            ELSE der.statement_end_offset 
         END - der.statement_start_offset) / 2) AS statement_executing,
    der.cpu_time,
    der.total_elapsed_time,
    ders.login_time,
    ders.host_name,
    ders.program_name,
    ders.host_process_id,
    ders.client_version,
    ders.client_interface_name
FROM sys.dm_exec_requests der
LEFT JOIN sys.dm_exec_sessions ders
    ON der.session_id = ders.session_id
CROSS APPLY sys.dm_exec_sql_text(der.sql_handle) dest
CROSS APPLY sys.dm_exec_query_plan(der.plan_handle) deqp
ORDER BY der.cpu_time DESC;
