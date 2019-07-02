Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D87525D283
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2019 17:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725851AbfGBPQA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 2 Jul 2019 11:16:00 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49716 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfGBPQA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jul 2019 11:16:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=q+PhWL8LYdwYuyolp5vA2VDSqI/1xY/Oo+GTfAus3Ds=; b=T4bSGzgyG7P6n40dUbCcNcV9w
        ie0geSXFlhQqjnfO+LpetICHtSjG/+Sayxvo1kQxzEXLW2c8v+fhi/QFbGUlBl7nMYQ58/AVjPSdK
        GIJAREcYvtZLLeAznCrRBSp30IM7/sa4rGr1YbfGTxAvMwqRcUalID+YNlZdpcZXWMW/Fvs5hDx/W
        wD4d2xsvxQrpmj9cjWTDOnkOVJ3pBAD28PGNbdH5AdPSnFmAIOKa1UyaFaKjm0dF1+kUOtOE4IdvV
        FK9KW4L1O8YSiMqc/YfnAw03ybcIS4HvzYa2NEvmuA0OMgfI2MrruxcoEGo6LXSVbUvlmyaJwptb4
        r3lyv5Pfg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hiKVj-0004SE-5c; Tue, 02 Jul 2019 15:15:59 +0000
Date:   Tue, 2 Jul 2019 08:15:59 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Sheriff Esseson <sheriffesseson@gmail.com>
Cc:     skhan@linuxfoundation.org, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [linux-kernel-mentees] [PATCH v5] Doc : fs : convert xfs.txt to
 ReST
Message-ID: <20190702151559.GE1729@bombadil.infradead.org>
References: <20190702123040.GA30111@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702123040.GA30111@localhost>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 02, 2019 at 01:30:40PM +0100, Sheriff Esseson wrote:
> +++ b/Documentation/filesystems/index.rst
> @@ -40,4 +40,5 @@ Documentation for individual filesystem types can be found here.
>  .. toctree::
>     :maxdepth: 2
>  
> -   binderfs.rst
> +   binderfs
> +   xfs

I don't think this makes sense.  Look:

Kernel API documentation
------------------------
...
   filesystems/index

but the contents of xfs.rst are not kernel API documentation.  We have
precedent in Documentation/index.rst for:

Filesystem Documentation
------------------------

The documentation in this section are provided by specific filesystem
subprojects.

.. toctree::
   :maxdepth: 2

   filesystems/ext4/index

but that looks more like the xfs-delayed-logging-design.txt and
xfs-self-describing-metadata.txt files.

I think Documentation/filesystems/xfs.rst should be part of the
admin guide.  Furtnately, ext4 has again led the way here, and
Documentation/admin-guide/ext4.rst already exists.
