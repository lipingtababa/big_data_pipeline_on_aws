for VARIABLE in {1000..10000}
do
        aws --region us-west-2 kinesis put-record  --stream-name logger --data "Hello, Stream $VARIABLE\r\n" --partition-key "msg$VARIABLE"
done

