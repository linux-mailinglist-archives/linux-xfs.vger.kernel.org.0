Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7231829E7D1
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Oct 2020 10:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgJ2Jwk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Oct 2020 05:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgJ2Jwj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 05:52:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE7DC0613D5
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 02:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=BogXvcqL2rtUrufUPy8/reQDdP
        4wJMxVhEKtKgmxx5MtiQsqY8pmNs00BNS/7+Pr9jR6HxTnhom4iTOTujtLT363j31dRm+lNGx29RE
        BkJsyOb0uK+9Kwk6Vcn7C2cmAPUxhURKoNrlokDFU1fULu8CviDs2Sp2fXNrTsUPKl4bkjebNZOgG
        /CqUOIGquxme0raBJWQf8Ds0jRGH8JJ+JUqv2+1wYo1GO00JI8rjY96Oj/PzpEOBSg/C4syJ3KIzD
        /IrtVYXckh4nSGneekvjUnLb442Os1uKbKPk0nKsC6ZWRgUph8V01R8piytBVNBTCcvXjtE3mritY
        1mcH0XeA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4aw-0001na-M3; Thu, 29 Oct 2020 09:51:46 +0000
Date:   Thu, 29 Oct 2020 09:51:46 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/26] xfs_quota: support editing and reporting quotas
 with bigtime
Message-ID: <20201029095146.GR2091@infradead.org>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375539460.881414.16375144747744518990.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375539460.881414.16375144747744518990.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
