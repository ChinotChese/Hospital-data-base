--Tìm tất cả những bệnh nhân không có đơn thuốc 
SELECT * 
FROM PATIENT 
WHERE P_ID NOT IN (SELECT P_ID FROM PRESCRIPTION)

--Trong khoa nhi bác sĩ nào làm việc tại nhiều phòng khám nhất
SELECT TOP 1 D.D_ID, COUNT(D.D_ID) AS NUM
FROM DOCTOR AS D JOIN LAB_CHECK AS LC ON D.D_ID = LC.D_ID
GROUP BY D.D_ID 
ORDER BY NUM DESC

--Tìm ra phòng khám mà khám được nhiều bệnh nhân nhất trong ngày 1/5/2021
SELECT TOP 1 LC.L_ID, COUNT(LC.L_ID) AS NUM
FROM LAB AS L JOIN LAB_CHECK AS LC ON L.L_ID = LC.L_ID
WHERE DAY(LC.LC_DATE) = 1 
AND LC.LC_DISEASE IS NOT NULL
GROUP BY LC.L_ID
ORDER BY NUM DESC

--Vào ngày 1/5/2021 tìm xem y tá nào làm việc cùng bác sĩ Vĩnh Bích Hậu và làm việc tại phòng nào
SELECT RS.D_ID, D.D_NAME, RS.N_ID 
FROM DOCTOR AS D JOIN ROOM_SHIFT AS RS ON D.D_ID = RS.D_ID
WHERE D_NAME = N'Vĩnh Bích Hậu'

--Tìm đơn thuốc được kê nhiều loại thuốc nhất
SELECT BD_ID, SUM(QUANTITY) AS DRUG_QUANTITY
FROM BILL_DETAIL
GROUP BY BD_ID
HAVING SUM(QUANTITY) >= (SELECT TOP 1 SUM(QUANTITY) AS C FROM BILL_DETAIL GROUP BY BD_ID ORDER BY C DESC)
HAVING SUM(QUANTITY) >= (SELECT MAX(QUANTITY) FROM BILL_DETAIL)
ORDER BY DRUG_QUANTITY DESC

--Tìm nhà thuốc bán được nhiều loại thuốc nhất
SELECT *
FROM PHARMACY AS PH JOIN DRUG AS D ON PH.NT_ID = D.NT_ID JOIN BILL_DETAIL AS BD ON D.T_ID = BD.T_ID
SELECT TOP 1 PH.NT_ID, COUNT(PH.NT_ID) AS C
FROM PHARMACY AS PH JOIN DRUG AS D ON PH.NT_ID = D.NT_ID JOIN BILL_DETAIL AS BD ON D.T_ID = BD.T_ID
GROUP BY PH.NT_ID
ORDER BY C DESC

--Tìm bệnh nhân khám ở nhiều khoa nhất
SELECT P_ID, COUNT(P_ID) AS NUM_OF_EXAMINATIONS
FROM LAB_CHECK
GROUP BY P_ID
HAVING COUNT(P_ID) >= (SELECT TOP 1 COUNT(P_ID) FROM LAB_CHECK GROUP BY P_ID ORDER BY COUNT(P_ID) DESC)
ORDER BY NUM_OF_EXAMINATIONS DESC

--Trong 10 bệnh nhân có hóa đơn tiền thuốc cao nhất(không tính BHYT), bệnh nhân nào là bệnh nhân nội trú?
SELECT TOP 10 I.I_ID, P.P_NAME, CB.PRICE 
FROM IMPATIENT AS I JOIN PATIENT AS P ON I.P_ID = P.P_ID JOIN LAB_CHECK AS LC ON P.P_ID = LC.P_ID JOIN CHECK_BILL AS CB ON LC.LC_ID = CB.LC_ID
ORDER BY PRICE DESC

--Tìm những thuốc có số lượng bé hơn 10
SELECT *
FROM DRUG
WHERE T_QUANTITY < 10

--Tìm trung bình doanh thu của 2 nhà thuốc 
SELECT PH.NT_ID, SUM(CB.PRICE)/COUNT(PH.NT_ID) AS AVG_REVENUE
FROM PHARMACY AS PH JOIN BILL_OF_PHARMACY AS BOP ON PH.NT_ID = BOP.NT_ID JOIN PRESCRIPTION AS PR ON BOP.PR_ID = PR.PR_ID JOIN LAB_CHECK AS LC ON PR.LC_ID = LC.LC_ID JOIN CHECK_BILL AS CB ON LC.LC_ID = CB.LC_ID
GROUP BY PH.NT_ID

--Tìm trung bình số bệnh nhân đến khám tại các phòng khám
SELECT L.L_ID, COUNT(LC.P_ID)/COUNT(P.P_ID) AS AVG_PATIENT
FROM LAB AS L JOIN LAB_CHECK AS LC ON L.L_ID = LC.L_ID JOIN PATIENT AS P ON LC.P_ID = P.P_ID
GROUP BY L.L_ID
