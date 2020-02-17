Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF6C16140C
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2020 14:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgBQN52 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Feb 2020 08:57:28 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59348 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgBQN52 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:57:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Px3sPDq429b5w/etS6pax4zhMH
        MEJ6VAQiN206AOt9nsBbElWwk4vvLMrgZlFklKfYew8OYpACB4cZuFun76OO7wlZ0mD1z2j33uRgh
        lAS1p6a0ZJ87vZaaAh7aSlJUuwR2sUAM/xBDV8X3BlwB8/JqJJZ+53vvDuDr3wSTUngx0VD7WuDdM
        MB6SB2x3Dx69bcG61iDrRaWcfwMuOR8Tg1cBJMesTD22gxWoDa7BhJzgPsaaHpae20bVOodQTtjTy
        EkE8HUYWjJQIS6QbwUmLvJS5l03xPgKd4xV24fEr4WdIct5RfPbOcuXzWH9MCXwtii1ylQL7AXYLh
        ZdBHe/Bw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gtr-0003gq-NY; Mon, 17 Feb 2020 13:57:27 +0000
Date:   Mon, 17 Feb 2020 05:57:27 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] libxfs: complain when write IOs fail
Message-ID: <20200217135727.GM18371@infradead.org>
References: <158086364511.2079905.3531505051831183875.stgit@magnolia>
 <158086365728.2079905.9556999948179065078.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086365728.2079905.9556999948179065078.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
