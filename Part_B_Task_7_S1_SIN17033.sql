SET SERVEROUTPUT ON;

--PL/SQL Procedure – Question 2
CREATE OR REPLACE PROCEDURE DVD_COST_VS_AVG_BY_YEAR IS
    CURSOR c1 IS
        SELECT 
            Title,
            Year,
            Cost,
            AVG(Cost) OVER (PARTITION BY Year) AS AvgYearCost,
            Cost - AVG(Cost) OVER (PARTITION BY Year) AS Diff
        FROM DVD
        ORDER BY Year;
    v_rec c1%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('Title', 30) || ' | ' ||
                         RPAD('Year', 6) || ' | ' ||
                         RPAD('Cost', 8) || ' | ' ||
                         RPAD('Avg', 8) || ' | ' ||
                         'Diff');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 70, '-'));

    OPEN c1;
    LOOP
        FETCH c1 INTO v_rec;
        EXIT WHEN c1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_rec.Title, 30) || ' | ' ||
            RPAD(v_rec.Year, 6) || ' | ' ||
            RPAD(TO_CHAR(v_rec.Cost, '$999.99'), 8) || ' | ' ||
            RPAD(TO_CHAR(v_rec.AvgYearCost, '$999.99'), 8) || ' | ' ||
            TO_CHAR(v_rec.Diff, '$999.99')
        );
    END LOOP;
    CLOSE c1;
END;
/

--PL/SQL Procedure – Question 3

CREATE OR REPLACE PROCEDURE CUMULATIVE_RENTAL_BY_MOVIE IS
    CURSOR c2 IS
        SELECT 
            c.FirstName,
            d.Title,
            d.Cost,
            SUM(d.Cost) OVER (ORDER BY d.Title, c.FirstName ROWS UNBOUNDED PRECEDING) AS RunningTotal
        FROM DVD_RENTAL r
        JOIN CUSTOMER c ON r.CustomerID = c.CustomerID
        JOIN DVD d ON r.TapeID = d.TapeID
        ORDER BY d.Title, c.FirstName;
    v_row c2%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('Name', 15) || ' | ' ||
                         RPAD('Movie', 30) || ' | ' ||
                         RPAD('Cost', 8) || ' | ' ||
                         'Cumulative');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 70, '-'));

    OPEN c2;
    LOOP
        FETCH c2 INTO v_row;
        EXIT WHEN c2%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_row.FirstName, 15) || ' | ' ||
            RPAD(v_row.Title, 30) || ' | ' ||
            RPAD(TO_CHAR(v_row.Cost, '$999.99'), 8) || ' | ' ||
            TO_CHAR(v_row.RunningTotal, '$999.99')
        );
    END LOOP;
    CLOSE c2;
END;
/

EXEC DVD_COST_VS_AVG_BY_YEAR;
EXEC CUMULATIVE_RENTAL_BY_MOVIE;

