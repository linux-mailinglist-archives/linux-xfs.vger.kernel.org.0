Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A3534ABA7
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Mar 2021 16:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhCZPm0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 26 Mar 2021 11:42:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38603 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230297AbhCZPmE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Mar 2021 11:42:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616773323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=AAG5JV/XvJZ+KOyjuzUdtKv9eJKNmT3Zl3jgHy8v/9M=;
        b=QZli+GeW9DESbllAen1hWZkJEEiMFp2SMikyOceq3gVqkis+nee8cct+wtgVCwlrq6e1aw
        e4bZBtGy12lINLaGfDkKrqZng8kqeNL8cPfPw81uZFnVYyoRHuEdim9Qs1pFB+PNoVWHOe
        sA/7hctt2ojbwk+sSsLnx73WyezJOHs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-qn6abOPbOIK6L00KN3SSUg-1; Fri, 26 Mar 2021 11:42:00 -0400
X-MC-Unique: qn6abOPbOIK6L00KN3SSUg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 506B593C;
        Fri, 26 Mar 2021 15:39:41 +0000 (UTC)
Received: from bfoster (ovpn-113-24.rdu2.redhat.com [10.10.113.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A43DE10023AB;
        Fri, 26 Mar 2021 15:39:40 +0000 (UTC)
Date:   Fri, 26 Mar 2021 11:39:38 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: xfs ioend batching log reservation deadlock
Message-ID: <YF4AOto30pC/0FYW@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

We have a report of a workload that deadlocks on log reservation via
iomap_ioend completion batching. To start, the fs format is somewhat
unique in that the log is on the smaller side (35MB) and the log stripe
unit is 256k, but this is actually a default mkfs for the underlying
storage. I don't have much more information wrt to the workload or
anything that contributes to the completion processing characteristics.

The overall scenario is that a workqueue task is executing in
xfs_end_io() and blocked on transaction reservation for an unwritten
extent conversion. Since this task began executing and pulled pending
items from ->i_ioend_list, the latter was repopulated with 90 ioends, 67
of which have append transactions. These append transactions account for
~520k of log reservation each due to the log stripe unit. All together
this consumes nearly all of available log space, prevents allocation of
the aforementioned unwritten extent conversion transaction and thus
leaves the fs in a deadlocked state.

I can think of different ways we could probably optimize this problem
away. One example is to transfer the append transaction to the inode at
bio completion time such that we retain only one per pending batch of
ioends. The workqueue task would then pull this append transaction from
the inode along with the ioend list and transfer it back to the last
non-unwritten/shared ioend in the sorted list.

That said, I'm not totally convinced this addresses the fundamental
problem of acquiring transaction reservation from a context that
essentially already owns outstanding reservation vs. just making it hard
to reproduce. I'm wondering if/why we need the append transaction at
all. AFAICT it goes back to commit 281627df3eb5 ("xfs: log file size
updates at I/O completion time") in v3.4 which changed the completion
on-disk size update from being an unlogged update. If we continue to
send these potential append ioends to the workqueue for completion
processing, is there any reason we can't let the workqueue allocate the
transaction as it already does for unwritten conversion?

If that is reasonable, I'm thinking of a couple patches:

1. Optimize current append transaction processing with an inode field as
noted above.

2. Replace the submission side append transaction entirely with a flag
or some such on the ioend that allocates the transaction at completion
time, but otherwise preserves batching behavior instituted in patch 1.

Thoughts?

Brian

