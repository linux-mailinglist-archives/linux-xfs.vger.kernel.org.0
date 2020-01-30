Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C68E714E0B1
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Jan 2020 19:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgA3SWb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 30 Jan 2020 13:22:31 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:49552 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729289AbgA3SWb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 13:22:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=++8pYw6xaiYEVLlb1onJOWhDN60n8MzvkY0uyvv976U=; b=qFt4MHAZIhvQ4xugVutbkSEjl
        56nuSI2eyYF6lx/nVdTe2IPYYyatVfRlq7TDW1hMMpDB/STkbihGFwbiW5x+AO4PE8tva7fRw6mIZ
        ih8UrlzquNX5UeAfNR75lNr+xjo6bKa+iVpqEStIAOfymTd8gIfBU3IgcCNXu8RSaTz1IMpPfQyS1
        pV8+MUUtAmlihWCaniCM+Y4VkKRxk+Um63YBMOn7jbO4wnmV4/LlWFrpbvFXlvJJhN0O7Tw2E3a7N
        yB6E2f8+BtB5TUm14VSqhbhLBJRhvTDyctB+BgBmv/L8P/XGKDO2wfyZLHa5iKTaVkQRdrPewM5Zh
        7qwREnaxg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ixESU-000105-HA; Thu, 30 Jan 2020 18:22:30 +0000
Date:   Thu, 30 Jan 2020 10:22:30 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/8] xfs_repair: don't corrupt a attr fork da3 node when
 clearing forw/back
Message-ID: <20200130182230.GC27318@infradead.org>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
 <20200130181512.GZ3447196@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130181512.GZ3447196@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

While this looks functionally correct, I think the structure in
here is weird.  In libxfs we usually check that magic number first
and then branch out into helper that deal with the leaf vs node
format.  That is we don't do the xfs_attr3_leaf_hdr_from_disk call
for node format attrs, and also check the forward/backward pointers
based on the actual ichdr.  Maybe this code should follow that
structure?
