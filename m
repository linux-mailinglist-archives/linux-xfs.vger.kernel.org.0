Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B9524E607
	for <lists+linux-xfs@lfdr.de>; Sat, 22 Aug 2020 09:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgHVHQe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 22 Aug 2020 03:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgHVHQd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Aug 2020 03:16:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39440C061573
        for <linux-xfs@vger.kernel.org>; Sat, 22 Aug 2020 00:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YzP9u8pSQa4+LoXPmpPqHgR0WuRx6bLNOZUg9eBuHhQ=; b=NUOYn3UeCN6Bydp7NRTZ/qGHxK
        hahdwaYWchiNt002W7d9QYQFZ41KwJHLCFwFZ193NRMA/NWIskNslqHCA1DPik7lAPEjfOI1rqRAh
        CLts+nDE5VOT2mbUdnuTUwbKXf/mRrpBewVqAi8fgW9RIJAOuBEhKb7lweiUXxhJctoIXjzzZa2t+
        W8EsjCTetFD+6gAzMsl2xpmM/MxKbmFQFHyZtdFDU6kO38ItaT2YOD9SflpTPJ1DrD73igY+UJwaj
        3ju0sKmKhcFFIA6jZbsC7qRfge/V9dydUclyffhF0CYOPnJ/zTNEBWL/lVs2sGSb5OlePFGE3i6fR
        S+M7XVXQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9NlP-0000lT-Bw; Sat, 22 Aug 2020 07:16:31 +0000
Date:   Sat, 22 Aug 2020 08:16:31 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 05/11] xfs: move xfs_log_dinode_to_disk to the log code
Message-ID: <20200822071631.GE1629@infradead.org>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797592235.965217.10770400527713016921.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159797592235.965217.10770400527713016921.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 07:12:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move this function to xfs_inode_item.c to match the encoding function
> that's already there.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

An good reason to not move it towards its only caller in
fs/xfs/xfs_inode_item_recover.c?
