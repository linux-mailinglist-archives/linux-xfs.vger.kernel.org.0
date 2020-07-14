Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FE121EAD5
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jul 2020 10:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbgGNIB7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Jul 2020 04:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgGNIB6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 04:01:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A9CC061755
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=m66BYt22tkNri/EPWAoJ64P3laroN706pRTj5T3iJmE=; b=QaLNBeS1xFYgOTSRfx1Ks4EyX9
        OYTyVOypL4llBht6RfOmnz0KhDZAUF6cLqeNcQMn0cidNTYjKsRs4P0sIYWMen+XPTOWeJYEK5vvL
        50xSQ7Y+qdHMRt4TzrCV+Tfz/OrIdclAPsXzb7IsSp7TVZ8ZP6TxLOgmb+zZ5l7Oj8CavRwlgpfhR
        GqWoTSnqzBadvksL8fggeACJW7H/0EnsBRJIDGpPr7rS/iF6jIRYD1UrOpnbin6RWHDZ8k+ounvSE
        isgwVMGtqlOpS0MSdT40rdMSzfZOosds2UX5YFotfGyrPX2rQdBTZ6UfPk8BngBW33QE2myHfAdZG
        OEglbF+g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvFsy-00072k-Qe; Tue, 14 Jul 2020 08:01:56 +0000
Date:   Tue, 14 Jul 2020 09:01:56 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/26] xfs: refactor xfs_trans_dqresv
Message-ID: <20200714080156.GG19883@infradead.org>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469042968.2914673.12190449838909912585.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159469042968.2914673.12190449838909912585.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 13, 2020 at 06:33:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've refactored the resource usage and limits into
> per-resource structures, we can refactor some of the open-coded
> reservation limit checking in xfs_trans_dqresv.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
