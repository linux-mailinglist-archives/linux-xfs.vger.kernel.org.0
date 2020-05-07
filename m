Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B1F1C8223
	for <lists+linux-xfs@lfdr.de>; Thu,  7 May 2020 08:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgEGGG5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 May 2020 02:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgEGGG5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 02:06:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1E1C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 23:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4RxxdXuIBeN6ARSq0NbSSxvUq0kodixIoCl+WMxV20c=; b=ewvehAXf6d6r0KaXpiNs6J9hBr
        280y0jBa29QkUjbc/SChFnH0a1In9uFWx8+8D9jg6H14Xv0gb24RXqhYTgeeDV3P0fBk7T8GMS+ac
        8zS/aq16vZHPOd7S7+TPWE25rtftNRz9wVLvutuSThiXz6DKWTQu5OTbA5TRo4hI4ZA2Rju+oj0tT
        gHV8hM0dNpbd8iG3tUrH6vHQbk44xk5QhR0R6Lkkcmd0gga7zBqsrl3EU5bO2SQn9EXQ0Uf+1KrZM
        IYWUK8UNqh0IbGbfE7I9OJ7oV0TaktP9xI20LZEyN+p3viwvhLMzQ+tg49cPBlcoG/FUNgy936K8E
        mYvgfc0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWZgO-0005iP-TU; Thu, 07 May 2020 06:06:56 +0000
Date:   Wed, 6 May 2020 23:06:56 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/25] xfs: refactor adding recovered intent items to the
 log
Message-ID: <20200507060656.GA5335@infradead.org>
References: <158881329912.189971.14392758631836955942.stgit@magnolia>
 <158881342959.189971.5621808877331045450.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158881342959.189971.5621808877331045450.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 06, 2020 at 06:03:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During recovery, every intent that we recover from the log has to be
> added to the AIL.  Replace the open-coded addition with a helper.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
