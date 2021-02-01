Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE98330A76A
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Feb 2021 13:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhBAMSR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Feb 2021 07:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhBAMSO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Feb 2021 07:18:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E29AC061573
        for <linux-xfs@vger.kernel.org>; Mon,  1 Feb 2021 04:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GIETALdPNA2uM94UFFNDTP5D50sG2+znBqR1SQmFYUs=; b=RD/C5042znb3LbkjKUO/TGJjFI
        A3Fo13La43gwR1JloQhIbu5cbKvdQlUks+lhSfLY1ggdjHmR5V658fpq+b9XnMHp3JdXnYJVEzhRx
        +8wGBXhS8DVHMBpUG4QR97+iMKmcva4d8MliSbfL+W44mG0rQmPV6qlnMG04InVczxT1Su9IgfseG
        E8Wf5YQITBUbHNwStSI8VQYybyhetyXa99LiDLi4ltks4LJOp6VbsYJFcVisVU/80UtmShpX9tbJ2
        9gyjjsmq5Z3WyyQKVNo+4nTyKqa9GFIQLdTsgs8/Xlb8f5X7wJv/115H/vLJegtxiD/YetXSjbTbf
        bdhgmGXQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l6Y95-00DkOS-06; Mon, 01 Feb 2021 12:17:31 +0000
Date:   Mon, 1 Feb 2021 12:17:30 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 13/17] xfs: move xfs_qm_vop_chown_reserve to
 xfs_trans_dquot.c
Message-ID: <20210201121730.GB3271714@infradead.org>
References: <161214502818.139387.7678025647736002500.stgit@magnolia>
 <161214510164.139387.1578453347437699937.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161214510164.139387.1578453347437699937.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

So looking at what is left of this function after your first patch
I'd be tempted to just open code it.  Right now it has two callsites
which either to udqp/gdqp or pdqp, althoug with your late changes
we're even down to one.  And the current callers kinda duplicate
the checks in it, I need to look at the new code in a little more
detail, though.
