Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5F22CDFEA
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Dec 2020 21:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgLCUrj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 3 Dec 2020 15:47:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27338 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726761AbgLCUrj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 15:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607028373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RfYJsYDIiA6G7PWui7E2OSksUWEwDiIzFy4M1+XEM4M=;
        b=Tef9+qvOuwJpG/KBI4t0Q+fPo3ovUlekXUQ5kAAJ3nH/DoDoH+IiFVjzTgJwXrtRpjy4Od
        2yFBQHq2+/lohwUsKbUmN3WSomPYgREHB0AIkuFa88mhLjpTaN0x7rjM4a3JC9l1w5PYFP
        4nS0WOhuZQEIjYSGNsN+qpS0DRaRhbk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-YYEdJv-IMOWaG7Yw9wAtZg-1; Thu, 03 Dec 2020 15:46:11 -0500
X-MC-Unique: YYEdJv-IMOWaG7Yw9wAtZg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9BB4800D62
        for <linux-xfs@vger.kernel.org>; Thu,  3 Dec 2020 20:46:10 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E40B60BFA
        for <linux-xfs@vger.kernel.org>; Thu,  3 Dec 2020 20:46:10 +0000 (UTC)
Subject: [PATCH 1/3 V3] xfs_quota: document how the default quota is stored
From:   Eric Sandeen <sandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
References: <44dcd8f3-0585-e463-499f-44256d8bad8d@redhat.com>
 <2e9b1d0f-7ad8-b42a-ac2b-b1fdd9a9fb45@redhat.com>
Message-ID: <e9c369a2-43d2-c8a0-6be6-1d8070e8cd77@redhat.com>
Date:   Thu, 3 Dec 2020 14:46:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <2e9b1d0f-7ad8-b42a-ac2b-b1fdd9a9fb45@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Nowhere in the man page is the default quota described; what it
does or where it is stored.  Add some brief information about this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V3: stop trying, and just use Darrick's nice words.

diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
index dd0479cd..2a911969 100644
--- a/man/man8/xfs_quota.8
+++ b/man/man8/xfs_quota.8
@@ -178,6 +178,12 @@ to a file on
 where the user's quota has not been exceeded.
 Then after rectifying the quota situation, the file can be moved back to the
 filesystem it belongs on.
+.SS Default Quotas
+The XFS quota subsystem allows a default quota to be enforced
+for any user, group or project which does not have a quota limit
+explicitly set.
+These limits are stored in and displayed as ID 0's limits, although they
+do not actually limit ID 0.
 .SH USER COMMANDS
 .TP
 .B print


