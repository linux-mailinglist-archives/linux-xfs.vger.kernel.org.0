Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28DC281C1B
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Oct 2020 21:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgJBTfs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Oct 2020 15:35:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725991AbgJBTfs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 15:35:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601667347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3LFTSJs+F2CPdyaU2XSlq3803HDET9W1JurRN5D4wGY=;
        b=P8YBrwJ1ZGEFtuy9UgVL5Vx9ZzZjz4HXkBI3LRUxHOBMN3yFoy4KA1lXsiqp/ENfaoaPGq
        VZv2tp9cVvjIEq9X+K/C48qtNgbHc4M/YCH/1xmwOMYJ8GXpYTYTKzkooRz3GkGYsh6nxf
        BeBme2HHl3G9NLLG1u11iMJk2mkKg8M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475--hw_WhxKOOaytIDSShyBuA-1; Fri, 02 Oct 2020 15:35:45 -0400
X-MC-Unique: -hw_WhxKOOaytIDSShyBuA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF62710BBEE3;
        Fri,  2 Oct 2020 19:35:44 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75C1719C66;
        Fri,  2 Oct 2020 19:35:44 +0000 (UTC)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsdump: don't try to generate .ltdep in inventory/
Cc:     Thomas Deutschmann <whissi@gentoo.org>
Message-ID: <15af018c-caf7-71e7-c353-96775d7173ba@redhat.com>
Date:   Fri, 2 Oct 2020 14:35:44 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

.ltdep gets generated from CFILES, and there are none in inventory/
so trying to generate it in that dir leads to a non-fatal error:

Building inventory
    [LTDEP]
gcc: fatal error: no input files
compilation terminated.

inventory/ - like common/ - has files that get linked into other dirs,
and .ltdep is generated there.  So, simply remove the .ltdep generation
from the inventory/ dir.

Reported-by: Thomas Deutschmann <whissi@gentoo.org>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/inventory/Makefile b/inventory/Makefile
index cda145e..6624fba 100644
--- a/inventory/Makefile
+++ b/inventory/Makefile
@@ -12,5 +12,3 @@ LSRCFILES = inv_api.c inv_core.c inv_fstab.c inv_idx.c inv_mgr.c \
 default install install-dev:
 
 include $(BUILDRULES)
-
--include .ltdep

