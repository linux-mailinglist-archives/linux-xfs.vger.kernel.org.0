Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A065A20184E
	for <lists+linux-xfs@lfdr.de>; Fri, 19 Jun 2020 19:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387472AbgFSOgK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 19 Jun 2020 10:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387467AbgFSOgJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jun 2020 10:36:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A676C06174E
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jun 2020 07:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0wxzzyfRen+6zphIYc5mmFRpiOy81MsoiuZdogrZxyw=; b=LyUCkS24UEAIhDNdPuCti2fZ4L
        3P5GIRjEV61Qo8/Tln1HOCEm57GnjMc1JBJTjJIywydY0O6Gte1EmEZtybhNcS70XyseLaz2DJeC3
        pS0NcrZ8xq2GOPoIInhQJ1xbtciaIHrNU19gIrzbJlQMy5/nIu1VynLyCYhrrw7UurHBC8rhMSboS
        6WRUVsQSWGBuFyp2yxJjo46RiLsn016xiNuPgvf4tXZiPK0S1l5FA+kaS08xicyvpH9cr6VRtTE7U
        JJLRhym5oHNsnebsG/wxJcSf5cQIv1AD57Qg3+13/nLtoh9wrGCYiN/Txf2NvLNXtX4wxEfwT0qIW
        VT42z8WQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jmI7k-0002CS-NV; Fri, 19 Jun 2020 14:36:08 +0000
Date:   Fri, 19 Jun 2020 07:36:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com,
        hch@infradead.org
Subject: Re: [PATCH 2/7] xfs: Check for per-inode extent count overflow
Message-ID: <20200619143608.GB29528@infradead.org>
References: <20200606082745.15174-1-chandanrlinux@gmail.com>
 <20200606082745.15174-3-chandanrlinux@gmail.com>
 <20200608162425.GC1334206@magnolia>
 <1885585.BIgNe5D0sC@garuda>
 <20200609171003.GB11245@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609171003.GB11245@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I'm lost in 4 layers of full quotes.  Can someone summarize the
discussion without hundreds of lines of irrelevant quotes?
