package org.dzu.system.domain;

import java.util.List;

public class AuditInfoGroupedResult {
    private List<AuditInfo> auditInfos;

    // Getters and setters
    public List<AuditInfo> getAuditInfos() {
        return auditInfos;
    }

    public void setAuditInfos(List<AuditInfo> auditInfos) {
        this.auditInfos = auditInfos;
    }
}
