Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 501BED121E
	for <lists+linux-xfs@lfdr.de>; Wed,  9 Oct 2019 17:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731451AbfJIPKI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 9 Oct 2019 11:10:08 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58384 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731436AbfJIPKI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 11:10:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=je//nPMpqBDU6W/UgfkbpXAi8Ia7jO3K+U6WNwVmvkY=; b=KiyRUlKRdRLPkYlqVDuaGAkDF
        A3dHtKW142L9c/ZPb4PbRJzO1iv8aOvbWz9AFldaC7pm5y9WqEtwZSdoGM0Z82qqxVMAQe42ZRxbC
        KSjl97HkeeOLDRJRUJFWmRbVDgxOhghSfWAkHAQCdz9TohJrj8XkbSlnSwY9+H2FRyvFojR3sDJX7
        s/PpZnKXEV8VvwODkpBUA0lR7cEF6j5wFgVXeGuVzzUoriKSlmHKGt6XHtW0dAs9ZGtPzDKfQspBn
        uRrUGjp+16hPgGQXxym756l74z4roNMHrR/5FQEsTQYinjsLyr266uHOXSr8KR0cRg3TZcNsPkReq
        ewlS/61dg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iIDbM-0002v5-Ht; Wed, 09 Oct 2019 15:10:08 +0000
Date:   Wed, 9 Oct 2019 08:10:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v5 16/17] xfs: mount-api - switch to new mount-api
Message-ID: <20191009151008.GJ10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
 <157062069523.32346.10316532216437532792.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157062069523.32346.10316532216437532792.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 07:31:35PM +0800, Ian Kent wrote:
> The infrastructure needed to use the new mount api is now
> in place, switch over to use it.

I find it weird that you add the methods and params table first and
think the series would be a lot easier to understand if you just did
independent refatoring first and then a big switch over.

> +/*
> + * Set up the filesystem mount context.
> + */

Not exactly a very helpful comment, after all it is a method instance..

> +int xfs_init_fs_context(struct fs_context *fc)

This should be static.  Btw, for most of the STATICs in the series we'd
just use static these days as well.  And at least for method instances
STATIC actually never made any sense..
