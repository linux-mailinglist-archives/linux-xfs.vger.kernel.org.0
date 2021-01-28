Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392BB307346
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Jan 2021 10:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhA1J7A (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 28 Jan 2021 04:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbhA1J66 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 04:58:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B982C061574
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 01:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=EjBXndabfnGoDrxMCF4btd+dX0
        358u+skSXlp/8iSBB9T5Twmf1EAiCRseHTXqpGiZF08DHpPosrR8VajV17IyI+r++lXexYrpPED/e
        0V1Brw/S+VntVqp9JaMKu0wJHTJjxAF67UOkKVZHMf4cxDunScS74kmfvoJ3hnnLRovn7BSH3KPad
        9MWCPrhamkD/QvkI5xJihnVGs5/WJWkSHyDmKwzPZJeY74SRG/eXLvs/WELtRj0pYNWNlIpdqdv+3
        u1G9GLskbW7bwidb7HbrKeO+9d8EF7MQI0cApFbYS4CRvV3eqYe8qvzIrHb29EfUbWZzyHdixFIER
        k1Vf/7wg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l5445-008IGq-Q5; Thu, 28 Jan 2021 09:58:14 +0000
Date:   Thu, 28 Jan 2021 09:58:13 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 12/13] xfs: move xfs_qm_vop_chown_reserve to
 xfs_trans_dquot.c
Message-ID: <20210128095813.GH1973802@infradead.org>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181373258.1523592.242724679476042204.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181373258.1523592.242724679476042204.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
