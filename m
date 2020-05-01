Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D7F1C1B13
	for <lists+linux-xfs@lfdr.de>; Fri,  1 May 2020 19:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgEARDD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 May 2020 13:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728975AbgEARDC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 13:03:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE7FC061A0C
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 10:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=J8CO04lB+TyKsM7emMIjCzIRhEhD4crobB+y8Nm8tPk=; b=s1jCI5sFLPkipKhLp3aYck34lv
        vgW8tKnHwaJ2suco1kceMLL64ACoi33VKa33El+h49kqyTQvvB6D7OUO3XEo1g4Pr1kYXnJYvf4Er
        gmOzY5IC6qyTDPW8DY4Iqms5pKl5OJGUXR0FryYwiU6GoLKpF/b+koME90JrmNbhWfD00AQn2MTft
        /8lisKhMoZZZYpV8zziH95fy1u1hYAUpk3qf5KYUgDYQrVzrh3sziUIKCUxe6HeBdjHVUzmZWWLGN
        IHi3O7VxQyquMX6V26CKK0xYucYtr/22YabgneTTBkPklWLuJgZ/k549R0sXbtTvmfcytzjZPFRHq
        NH7O/93w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUZ42-0007TA-KQ; Fri, 01 May 2020 17:03:02 +0000
Date:   Fri, 1 May 2020 10:03:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 00/21] xfs: refactor log recovery
Message-ID: <20200501170302.GA16981@infradead.org>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
 <20200501101539.GA21903@infradead.org>
 <20200501165357.GU6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501165357.GU6742@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 09:53:57AM -0700, Darrick J. Wong wrote:
> >  - Setting XFS_LI_RECOVERED could also move to common code, basically
> >    set it whenever iop_recover returns.  Also we can remove the
> >    XFS_LI_RECOVERED asserts in ->iop_recovery when the caller checks
> >    it just before.
> 
> I've noticed two weird things about the xfs_*_recover functions:
> 
> 1. We'll set LI_RECOVERED if the intent is corrupt or if the final
> commit succeeds (or fails), but we won't set it for other error bailouts
> during recovery (e.g. xfs_trans_alloc fails).
> 
> 2. If the intent is corrupt, iop_recovery also release the intent item,
> but we don't do that for any of the other error returns from the
> ->iop_recovery function.  AFAICT those items (including the one that
> failed recovery) are still on the AIL list and get released when we call
> cancel_intents, which means that iop_recovery should /not/ be releasing
> the item, right?

LI_RECOVERED just prevents entering ->iop_recover again.  Given that
we give up after any failed recovery I don't think it matters if we set
it or not.  That being said, we should be consistent, and taking the
setting into the caller will force them to be consistent.

Well, releasing them will remove them from the AIL.  So I think the
manual release is pointless, but not actively harmful.  But again,
removing them is probably and improvements, as that means all the
releasing from the AIL is driven from the common code.
