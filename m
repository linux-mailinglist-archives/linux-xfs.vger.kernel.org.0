Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBE9A1613EE
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2020 14:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgBQNu0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Feb 2020 08:50:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57426 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgBQNu0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:50:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hx3PCriOWbgtSadUftJSSz0OVI7qd50r1S8LFxlhxC8=; b=AvrHgqYu/YEfQKaoTiZLmaey5u
        snaNsMkT+mzddpxPb/o5JCwe/BchtRkWDQqCa4GEveGrMPIuzLo869Vi67L3pW2cQiFaQ0qiXlreq
        a5ko7NR/mCF54rx+wQw2xFKb7XorlwfJf/qtaBkLBTAAxKUs0/lvCQRked/jIGRfCBCvs8PlV1KDW
        gNROY88S3GUBez3WPDw1TtF96BaOf4+L4zSS4w3I1UH8+ni/wEVL1zUiK57BFVADMZqbHnZ6R/H5c
        4iBMOPRT8NKUpNA3inWtaV1U9HPf+2YQ/rgyDie/sZI0GyP5cJE8Drvd1P9eWLlRII6sS4wTOrAXg
        Y08S9sRA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gn3-0008Sy-Vd; Mon, 17 Feb 2020 13:50:25 +0000
Date:   Mon, 17 Feb 2020 05:50:25 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>, alex@zadara.com
Subject: Re: [PATCH 2/7] mkfs: check root inode location
Message-ID: <20200217135025.GF18371@infradead.org>
References: <158086359783.2079685.9581209719946834913.stgit@magnolia>
 <158086361042.2079685.15091609361190214982.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086361042.2079685.15091609361190214982.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:46:50PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure the root inode gets created where repair thinks it should be
> created.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
