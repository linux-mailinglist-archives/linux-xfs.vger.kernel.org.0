Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5631B13C949
	for <lists+linux-xfs@lfdr.de>; Wed, 15 Jan 2020 17:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgAOQ0z (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 Jan 2020 11:26:55 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33646 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgAOQ0z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 11:26:55 -0500
Received: by mail-qt1-f195.google.com with SMTP id d5so16273684qto.0
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2020 08:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BGhoOyu5VQ9UNwECtfExQGuAJzqWLNe3068aiRd3j68=;
        b=N9MbVpGjbi4k9kiTHfugxxCqckr+FEPgRaTd1X13kFFNn75b2OUvIFegFjnLjH4MET
         vYHvGAv/cOaMEmtOO8gVpi25xQTiXiYNaLyRqrx7nJ22WyoLjGEe9PnBvg0thLlOi5tN
         vLSwngsRsi6ngXhfvRJQMXOtScF1i499fQboIHbYUwdCcRHcrovwlqPNkoF8l5B8C6xk
         zwDNP+6+/F2wp5Ak918pWlHJF76FP6OC+sswqBL8ciBYxn0R5C/pVF4Y9JQCRnOJSIEw
         k+WkZdWPlT1Nlfh6HzUYA97cC9iZdhJFTeA66t2cEmmsVdLY6n3QrGD0L/KbrRmCllm/
         ehuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BGhoOyu5VQ9UNwECtfExQGuAJzqWLNe3068aiRd3j68=;
        b=F+WuIQLaOBwgY2uNeTgflC7L6J4GdUBoXtU/LF8r2oW5zSBzOdtNuZEvt+/YgMaCCb
         WDUXrb3PpboG6pHjjTYuo+QWwcWAkVCsGmpSkwwTB0jmHtSoY9R5TlD0NIINJ/qwkznL
         BDqSCTX0zYp62scYIzWAiwjbQtn6Ullv64ij45sG2tMJdJqGTKJU877hjgg5KNCzuDHy
         6mTTg1GdY0Tg0J6cRLARXhCzXQw4i/9cMjNrSZjGMf7qQfLOGWSt7UCdHp6z77BIWZzy
         /vcB8xAHOLGXVb42zjMI8pmTw3YssJFYa3jfbTy12+Txbtm6Jn9el5en9ZTFd4pfU5S8
         +kHQ==
X-Gm-Message-State: APjAAAW6VmMOYtMf0J49ELbCG8pbEm4jHVqKfY56CMWT0l7mz3t5ivPV
        bbGjmpzkMWVqnAsMuKvG6TQ9Yg==
X-Google-Smtp-Source: APXvYqxK3fXxJYK2OHY5fNbL0IWIdwQXnxlcW9LltTOQTnJ8odVy9pqrM8Tc37VCTRCWaseM/4cyKQ==
X-Received: by 2002:ac8:4657:: with SMTP id f23mr4369118qto.378.1579105614247;
        Wed, 15 Jan 2020 08:26:54 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id z141sm8675109qkb.63.2020.01.15.08.26.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Jan 2020 08:26:53 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1irlVN-0001qT-27; Wed, 15 Jan 2020 12:26:53 -0400
Date:   Wed, 15 Jan 2020 12:26:53 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: RFC: hold i_rwsem until aio completes
Message-ID: <20200115162653.GC25201@ziepe.ca>
References: <20200114161225.309792-1-hch@lst.de>
 <20200114192700.GC22037@ziepe.ca>
 <20200115065614.GC21219@lst.de>
 <20200115132428.GA25201@ziepe.ca>
 <20200115153614.GA31296@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115153614.GA31296@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 04:36:14PM +0100, Christoph Hellwig wrote:

> synchronous and currently hack that up, so a version of the percpu_ref
> that actually waits for the other references to away like we hacked
> up various places seems to exactly suit your requirements.

Ah, yes, sounds like a similar goal, many cases I'm thinking about
also hack up a kref to trigger a completion to make it
synchronous.

Jason
