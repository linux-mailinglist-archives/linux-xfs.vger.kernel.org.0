Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD7829D460
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Oct 2020 22:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgJ1Vvw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Oct 2020 17:51:52 -0400
Received: from casper.infradead.org ([90.155.50.34]:44160 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbgJ1Vvv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:51:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0W2EIEWbo1w6xDIkVOEVV/+4jZKKPiyltI7OnASo7A0=; b=UcrnJoZJ+zuqtzXti3ABk1BBIK
        WJnmKzZbuYISTDOkXcQXSCuj9NjReQFzu6IizjXLyfHU89XoisQBzIq5AkNRswbeDIEdEiz+ESH2i
        7dBHaBFSpg5IdioT0CZj32/UmKSZDVzeYmhmwXluS9EElQTf54bd0QlP9vdpcnAVQ7qWdq/0UbLXq
        vkLxSfPBKC87VKH79AMpilER9wyz7iPOsmhWKycyZitTQY+fPNOln5GfWS1z+cdAIa/JScfcM9hus
        285jhvAuqTVLo1D0ncjUVcb/a6/F4UgGG9Zc7LWO/eYGueoF0j+mrS14MhTa7QQBwbziysnKdmcOA
        pARtna5g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXfxX-0000I4-DC; Wed, 28 Oct 2020 07:33:27 +0000
Date:   Wed, 28 Oct 2020 07:33:27 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: remove unnecessary parameter from
 scrub_scan_estimate_blocks
Message-ID: <20201028073327.GD32068@infradead.org>
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
 <160375512596.879169.13683347692314634844.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375512596.879169.13683347692314634844.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 04:32:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The only caller that cares about the file counts uses it to compute the
> number of files used, so return that and save a parameter.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
