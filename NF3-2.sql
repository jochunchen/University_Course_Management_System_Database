CREATE OR ALTER FUNCTION SplitStringToChars (@InputString VARCHAR(255))
RETURNS @CharTable TABLE (
    CharIndex INT,
    CharValue CHAR(1)
)
AS
BEGIN
    DECLARE @index INT = 1
    WHILE @index <= LEN(@InputString)
    BEGIN
        INSERT INTO @CharTable (CharIndex, CharValue)
        VALUES (@index, SUBSTRING(@InputString, @index, 1))
        SET @index = @index + 1
    END
    RETURN
END