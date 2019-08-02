Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E607D7F048
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Aug 2019 11:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388207AbfHBJTn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Aug 2019 05:19:43 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38249 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387876AbfHBJTn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 05:19:43 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so76409297wrr.5
        for <linux-xfs@vger.kernel.org>; Fri, 02 Aug 2019 02:19:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=AWW90I58JbC0qNw1B9zfM6Ib/6ksVuYisUHthaEluzs=;
        b=lqQc2kMp1fvndHziyWyhydQMOKRZvlMjFUvHN4cyBdVTKLD+zHaY+npdrnz2adSmQ6
         JS82P9nvSV4SgCtU1P6g9GGPeHrRAtnrbkEuGrJ+du+gwWteiN43c/6iDbssC+XMwTAr
         kAY8BMRot/kk/yNmeMjrFsOQ98e2KPWVAYbNa4Jzr77IU1/b4V0IDLbK/FqNW8rok8p3
         /BJkNzVZvjE9lIjJbvRC9Frh2jBhyMg1tLrVlpXgJxij7UMbFMQt91zk3I+r7oWjNrr6
         g8iNCTB9oUW69GGr/ZKmbQTK+ezF1B8xnD/QVeik0CKqPoHUNegjp3CZ5Cd84+xwX6FZ
         aDoQ==
X-Gm-Message-State: APjAAAXwH/BZD7VROFZ1PQlL7maQ1xvymXsXVkLrwhLpTyTKUcz7hphY
        jIf2+PAPi6cteMQ3CyAGSy/llQ==
X-Google-Smtp-Source: APXvYqwI+Edf+8WSAIuVXNdwAMHEunwYHZHkK1/ROixc64nej4MDkh74BNSr6DgHzuNsmKROuMiZFg==
X-Received: by 2002:a5d:4b8b:: with SMTP id b11mr65487799wrt.294.1564737581568;
        Fri, 02 Aug 2019 02:19:41 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id a67sm85805669wmh.40.2019.08.02.02.19.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 02:19:41 -0700 (PDT)
Date:   Fri, 2 Aug 2019 11:19:39 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca,
        jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] fibmap: Use bmap instead of ->bmap method in
 ioctl_fibmap
Message-ID: <20190802091937.kwutqtwt64q5hzkz@pegasus.maiolino.io>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca,
        jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com,
        linux-xfs@vger.kernel.org
References: <20190731141245.7230-1-cmaiolino@redhat.com>
 <20190731141245.7230-5-cmaiolino@redhat.com>
 <20190731231217.GV1561054@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731231217.GV1561054@magnolia>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick.

> > +		return error;
> > +
> > +	block = ur_block;
> > +	error = bmap(inode, &block);
> > +
> > +	if (error)
> > +		ur_block = 0;
> > +	else
> > +		ur_block = block;
> 
> What happens if ur_block > INT_MAX?  Shouldn't we return zero (i.e.
> error) instead of truncating the value?  Maybe the code does this
> somewhere else?  Here seemed like the obvious place for an overflow
> check as we go from sector_t to int.
> 

The behavior should still be the same. It will get truncated, unfortunately. I
don't think we can actually change this behavior and return zero instead of
truncating it.

> --D
> 
> > +
> > +	error = put_user(ur_block, p);
> > +
> > +	return error;
> >  }
> >  
> >  /**
> > -- 
> > 2.20.1
> > 

-- 
Carlos
