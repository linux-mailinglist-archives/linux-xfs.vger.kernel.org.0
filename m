Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 898EA17AAE4
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Mar 2020 17:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgCEQun (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Mar 2020 11:50:43 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60534 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgCEQum (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 11:50:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hnS+ggyb8O+THJPrRAL7Bq1UEO/ewxb2REWLGh2/ZJk=; b=JlDJ+OtW4kh7Ofb4Q4ZPsaakgX
        uzVl0SCc8yp+Ya9psfjR+EqRpOjUtqMGFtsXubai/rm84RnMpa+Ry9w3vyn8bG2IYSatW5GGHC4XM
        jqzUsWZhCHHzm2KVrvCWTYXaqn27i0DOgmjISWIdgCEiPqmm+OkEcQ3u2ay5cWIQ1o1CyIttg856D
        CcNl9KRp9qKcLNPI3mbZHrGWSZBn9hNK+vZ98rXto9OpQot+5mYEcUvNR7fxM4PcBD+uJrtV3DeDo
        2i/LPECS9DsePI5qn5oBsKtf0L/tjMWApS23EBiidAfmNyfXXH1x4ziYlac6YzjD8qSiCViH22ysw
        e/hzVbfQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9thq-0003dL-NB; Thu, 05 Mar 2020 16:50:42 +0000
Date:   Thu, 5 Mar 2020 08:50:42 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: check owner of dir3 data blocks
Message-ID: <20200305165042.GD7630@infradead.org>
References: <158294091582.1729975.287494493433729349.stgit@magnolia>
 <158294093423.1729975.14006020261164830361.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158294093423.1729975.14006020261164830361.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 28, 2020 at 05:48:54PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the owner field of dir3 data block headers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
