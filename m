Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8D72D5F16
	for <lists+linux-xfs@lfdr.de>; Thu, 10 Dec 2020 16:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389173AbgLJOrs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 10 Dec 2020 09:47:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34970 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391603AbgLJOrl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Dec 2020 09:47:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607611573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZM0Cf9hfjAmv+Ah5VZag15W6puA4SWfoO0l8QGXimFw=;
        b=SMCal5uMJ3T1nysBlcqmsTQVj8Mrdmepc5QGso56Gg/T8TZU2O9E+QYlcivGMyf2SWbPH+
        UqbXTtY4i3Ro5V6W4nOKVRiw78mxFg7RRNl8K31FsWGGD257HurpyCoJXkSPyOz+9LRmx6
        FLMvjFnGohDrRbHCCdc6gXlIqDCQ2HU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-mNVtjzmUNAydPC76mwX5Lg-1; Thu, 10 Dec 2020 09:46:11 -0500
X-MC-Unique: mNVtjzmUNAydPC76mwX5Lg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC3801009456
        for <linux-xfs@vger.kernel.org>; Thu, 10 Dec 2020 14:46:10 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96E8119713
        for <linux-xfs@vger.kernel.org>; Thu, 10 Dec 2020 14:46:10 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfs: don't drain buffer lru on freeze
Date:   Thu, 10 Dec 2020 09:46:05 -0500
Message-Id: <20201210144607.1922026-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series tweaks the xfs_log_quiesce() codepath to lift out the
explicit buffer target LRU draining and isolate it to the unmount path.
It's unnecessary to reclaim all buffers on filesystem freeze or
read-only remount, and this also causes such operations to stall if a
read heavy workload is running in parallel.

Patch 1 is a simple rename and patch 2 implements the functional change.
Thoughts, reviews, flames appreciated.

Brian

Brian Foster (2):
  xfs: rename xfs_wait_buftarg() to xfs_buftarg_drain()
  xfs: don't drain buffer lru on freeze and read-only remount

 fs/xfs/xfs_buf.c   | 30 ++++++++++++++++++++----------
 fs/xfs/xfs_buf.h   | 11 ++++++-----
 fs/xfs/xfs_log.c   |  8 +++++---
 fs/xfs/xfs_mount.c |  4 ++--
 fs/xfs/xfs_trace.h |  2 +-
 5 files changed, 34 insertions(+), 21 deletions(-)

-- 
2.26.2

