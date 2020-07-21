Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF1A2282E1
	for <lists+linux-xfs@lfdr.de>; Tue, 21 Jul 2020 16:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgGUOzg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 Jul 2020 10:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGUOzf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 10:55:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3F7C061794
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 07:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eQoGKvGyoIZu48Fl9qBUzdXokZHAQbkK25uWl2gd5lM=; b=ByUISSVOXlYwi6VI+92cfsSjhb
        /U54SdMorZ40zjWp42nB6Z+wS8AHnALlkWYImUlJf19YVVu1vDojTEgsp0Rk23m3w5dgQPK5B/DC/
        v93ZsauVjszYeZn5V3fbKS857TuM3iX4sh5g8TzLoMxR8Z6AfSPxUPafzOCALU4MmM4Zr1Yb3XG4X
        H1MsIjKe68VWCPNIAd3Iq67MPvLpDENNFv7myF0STw5MtZe1jeA+GiSfcKRATxWLddYdXXSWohrn2
        pYgd7DoLBleIa40WhRueaS62pz36aTelY0lbVP5JwGUd84vBmrNLhRNnYAKWdu+1SfXQF2oh4DKmV
        f7n5Hkow==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxtg6-0001m1-85; Tue, 21 Jul 2020 14:55:34 +0000
Date:   Tue, 21 Jul 2020 15:55:34 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs: remove the XFS_QM_IS[UGP]DQ macros
Message-ID: <20200721145534.GD6208@infradead.org>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488194524.3813063.1536581067461068233.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159488194524.3813063.1536581067461068233.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 11:45:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove these macros and use xfs_dquot_type() for everything.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
