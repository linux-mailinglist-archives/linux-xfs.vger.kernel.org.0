Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB6B1C74EA
	for <lists+linux-xfs@lfdr.de>; Wed,  6 May 2020 17:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgEFPbL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 May 2020 11:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729619AbgEFPbL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:31:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001DDC061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oNP7ih4XLLZ9KeqOB9d5gKEsig5HWfrghWLNyfgSrPk=; b=pOObYHJKOjeoPqPH84M0fxU3gH
        /CXOvmeLAaZFF0rlMWVbo58EO1ax5hxE6MTbl3jMiKQDWZ1W7aBfeHwsDWFeA5vMHxltsqBbBKttg
        pKYoA8+kYUDJKx+fNOw2AdMYNzpv9FqK9HbZrLLsHX5QPumguSlezulEypD21e9jmZw7K43juGhY0
        suCWzc3bO3P21meWw4d7YiKq2zRO0gWlU+QucW6/DY+gOtxr9Clbg7u9yeBw9MqygjlAfotM52Fjc
        ad46DN80ocrQeoLq1Uz8gLhzKP2oo65SU428R3p4bdwA9DWFGvg2nkaPKknnKfA/d5/90xXT4WDEY
        rqieyNBA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWM0s-0005gI-SI; Wed, 06 May 2020 15:31:10 +0000
Date:   Wed, 6 May 2020 08:31:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/28] xfs: refactor adding recovered intent items to the
 log
Message-ID: <20200506153110.GA7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864117369.182683.15552207685086345850.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864117369.182683.15552207685086345850.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:12:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During recovery, every intent that we recover from the log has to be
> added to the AIL.  Replace the open-coded addition with a helper.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Second thoughts: given that the helper is totally generic, maybe
name it xfs_trans_ail_insert and keep it in the generic AIL code?
