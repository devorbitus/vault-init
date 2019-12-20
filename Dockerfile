FROM sethvargo/vault-init:1.1.0 as builder

FROM centurylink/ca-certs
COPY --from=builder /vault-init /
CMD ["/vault-init"]
