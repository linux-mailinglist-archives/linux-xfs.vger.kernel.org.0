Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5541A62A09
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Jul 2019 22:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731867AbfGHUAP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Jul 2019 16:00:15 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40706 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731856AbfGHUAP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jul 2019 16:00:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OftWB+fqpTDT3WzVYS7HU++mS8BFzNeNumAJnqIaJmo=; b=G5yZVp14DG+ytt0RNwePKeqhT
        pefLGSuwfxcumY3FPEA1Qdh2WZ2DMYNkEZJdDaceyL50bBrn3CNbopCQZtUhKTDVJ/C7kuZCh7pc0
        C16L1G7hLRXsVoDePUPI1F/u4WE4HXt6xZyfWbRMl+xW8RDvdmWGiCJRhGCDNPaWsRM3yn6WwCYjU
        zYaeASAEUCeiA/jyKLPUGwOiC4G0eBMrKLiYQ7Rbk+VWVmJIovkAi8V1MlaoS4XdKSxUUsHIJdDWV
        Sij1eZP2DWa2/QJcwx0/aJjJl+ax3SMYjgAM/7xOxN/f/JcSpWJ/H6i6woHH1GjGKA1Rda8E5GCOv
        MIrZb3J0Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hkZo5-0003QN-18; Mon, 08 Jul 2019 20:00:13 +0000
Date:   Mon, 8 Jul 2019 13:00:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Sheriff Esseson <sheriffesseson@gmail.com>
Cc:     skhan@linuxfoundation.org, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [Linux-kernel-mentees] [PATCH] Doc : fs : move xfs.txt to
 admin-guide
Message-ID: <20190708200013.GA1548@infradead.org>
References: <20190705131446.GA10045@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705131446.GA10045@localhost>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The subjet line seems to be a bit messed up.
