Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2381216B6DC
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Feb 2020 01:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgBYAtS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Feb 2020 19:49:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26857 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727976AbgBYAtS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:49:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582591757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=oIyQBMQQ4E5E0FKkSGs7lxKmKm/RkB+fqbnodqd6YjA=;
        b=GZmJNCz8tdr67ot4izQefzMc8qqmViBDQzE7JsF5J+dtcycQ6WlD6IieRETsDD8fLp3jHm
        4b+fCo5zwKA7pBiS5teac3SG6Ri+QrZCesFncK3tcgAykdcwbHEu592bbO+IjKcibXnceF
        kdqUyUBI/ZkaaHtf0kfVXd2p75rE4d4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-74fZ6E2HMWufsYG4h5BEpw-1; Mon, 24 Feb 2020 19:49:16 -0500
X-MC-Unique: 74fZ6E2HMWufsYG4h5BEpw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01D5B1005512;
        Tue, 25 Feb 2020 00:49:15 +0000 (UTC)
Received: from Liberator.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9234E26FDD;
        Tue, 25 Feb 2020 00:49:14 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: mark ARM OABI as incompatible in Kconfig
Cc:     linux-arm-kernel@lists.infradead.org
Message-ID: <ee78c5dd-5ee4-994c-47e2-209e38a9e986@redhat.com>
Date:   Mon, 24 Feb 2020 16:49:12 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The old ARM OABI's structure alignment quirks break xfs disk structures,
let's just move on and disallow it rather than playing whack-a-mole
for the infrequent times someone selects this old config, which is
usually during "make randconfig" tests.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index e685299eb3d2..043624bd4ab2 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -2,6 +2,8 @@
 config XFS_FS
 	tristate "XFS filesystem support"
 	depends on BLOCK
+	# We don't support OABI structure alignment on ARM
+	depends on (!ARM || AEABI)
 	select EXPORTFS
 	select LIBCRC32C
 	select FS_IOMAP

