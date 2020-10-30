Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F1629FF8E
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Oct 2020 09:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgJ3IVZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Oct 2020 04:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgJ3IVZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Oct 2020 04:21:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B321C0613CF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Oct 2020 01:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bUHVRT4h86sIHCnAfniOEezkU0LgKxJWRB3TYRu/7SU=; b=Cr+qiuPUlrOWEG90I2V6cR/yc3
        Kp4NSv62QWrS4aIbrzzGo+eEZ1UKPqcMbQ63unN6Cnau626hnNOGitRW3np1X3Dv0nNsZ7/zzRMI7
        C4F6LL2WY79G/ak6MF+ZSyljfX4/t/ppV4/TGG0AIOQmf3jrbK7LTYRqAewYBf3XSaN3z/h9Pe7Kb
        WYR8rOFFpzp8fj5vYaCIQJPtB72KoidnhYqrsUt6ORy9gUcSYJ+rOmlAEQIRQDlZSVxzOgKOYquTY
        E4ofeUuXiL+WXAC8lpt3+T2w10hKzEa/cF4niz0ReDLSxDflYss+bUsgJZQtvibohOElXNczXJleP
        8nw/2jTA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kYPf0-0000EW-3U; Fri, 30 Oct 2020 08:21:22 +0000
Date:   Fri, 30 Oct 2020 08:21:22 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/26] xfs_quota: convert time_to_string to use time64_t
Message-ID: <20201030082122.GB303@infradead.org>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375527834.881414.2581158648212089750.stgit@magnolia>
 <20201029094712.GI2091@infradead.org>
 <20201029173234.GE1061260@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029173234.GE1061260@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 10:32:34AM -0700, Darrick J. Wong wrote:
> It's a setup to avoid long lines of nested function call crud once we
> get to patch 23.  Without the local variable, the fprintf turns into
> this ugliness:

Ok.
