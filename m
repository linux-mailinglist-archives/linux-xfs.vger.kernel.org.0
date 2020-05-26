Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4AEE1B8834
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Apr 2020 19:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgDYRjH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 25 Apr 2020 13:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYRjH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 13:39:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3C9C09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 10:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=W0WZTNRYvQJQ3DTi7dulEYFdYVL4mMC8FkgKc5HFpgs=; b=geO2pppQSgdVAQNePUwYVpgWpK
        jPLy6+hllVcNDM7l91IVw/6cBXKW+8RZ1EpjCpZMZ29Q9w3OWq1UAv+gKDNVbMMX082Q0NZL5vnqY
        HFe12QDIQ3mDhvJAqKX7Zqq+qlkWFG2lkPST14YT5GUuFapMY070a1x6vNWkT5gSw04WvwsfcA/ro
        zC0ERDaWQXjnnsbWozgKQegnWkOAcAGYXs5S6/473gpfsaksyfqNpdGZc58i8zMP54O/3Z1YLt8BS
        i/ac4lBb0bCx43+mI/sIUIKUf41K5jvi/5qt9GZHapG8Dyg6YKV+03gUCvhJBuIQa4XWzBFXigz+U
        Xzlbu2DQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSOlf-0004FT-B6; Sat, 25 Apr 2020 17:39:07 +0000
Date:   Sat, 25 Apr 2020 10:39:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 13/13] xfs: remove unused shutdown types
Message-ID: <20200425173907.GJ30534@infradead.org>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-14-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422175429.38957-14-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 01:54:29PM -0400, Brian Foster wrote:
> Both types control shutdown messaging and neither is used in the
> current codebase.

Hmm, I'm pretty sure I submitted the same patch a few weeks ago :)

Because of that it obviously looks fine, of course:

Reviewed-by: Christoph Hellwig <hch@lst.de>
