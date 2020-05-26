Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4545C1CC79D
	for <lists+linux-xfs@lfdr.de>; Sun, 10 May 2020 09:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgEJH1I (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 10 May 2020 03:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbgEJH1I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 May 2020 03:27:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83318C061A0C
        for <linux-xfs@vger.kernel.org>; Sun, 10 May 2020 00:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kKa5QNifwza2AdH9kZyYQQOCQVq856Ek0hd//DMa8vc=; b=Y+cg5WD6hMUl04cfaPwWRo+gqq
        xx8td4euLa+yYNKtwvZHySP4Hjv8ZOFakEKTPNdten1hsk6YLrmksOpc0wj3Qzq8yO661uUIE/hpW
        XV0bUJXg0TNdaeQ+WrjGGpgB9eMuF+IfIsW4s9LrcUfr0SvHwrRndEo57NQfvlT7v4NhAC5orgbo2
        3O5z6wQpqu2wToLtJ5tmxv/Jrh1i1GObfzpv8BfVXWcHcZeVxZNRZ58JnwpwNq35WHzas+koUx54n
        X/VyY06nxqV07aQ19+K6YV8Pt0TFJGhbWGmQ/PN5JK4fnfgH/BS+bKrB4c6dOQNTKtQN04UM1E+xM
        jSjFCllw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXgMd-0007UV-Qe; Sun, 10 May 2020 07:27:07 +0000
Date:   Sun, 10 May 2020 00:27:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/16] xfs_repair: complain about extents in unknown state
Message-ID: <20200510072707.GF8939@infradead.org>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904189253.982941.5576924652917825655.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904189253.982941.5576924652917825655.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:31:32AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During phase 4, if we find any extents that are unaccounted for, report
> the entire extent, not just the first block.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
